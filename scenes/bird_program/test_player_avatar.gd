extends CharacterBody2D

@export_group('move')
@export var speed: int = 300
@export var acceleration: int = 600
@export var friction: int = 1000
var direction: Vector2 = Vector2.ZERO
var can_move: bool = true
var dash: bool = false
@export_range(0.1, 2) var dash_cooldown: float = 0.5
var ducking: bool = false

var jump_strength: int = 500
var gravity: int = 600
var terminal_velocity: int = 500
var jump: bool = false
var faster_fall: bool = false
var gravity_multiplier: int = 1

@onready var coyote: Timer = %Coyote
@onready var jump_buffer: Timer = %JumpBuffer
@onready var dash_cooldown_timer: Timer = %DashCooldown


func _ready():
	dash_cooldown_timer.wait_time = dash_cooldown


func _process(delta) -> void:
	apply_gravity(delta)
	
	if can_move:
		get_input(delta)
		apply_movement(delta)


func get_input(delta) -> void:
	direction.x = Input.get_axis("move_left", "move_right")
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or coyote.time_left:
			jump = true
		
		if velocity.y > 0 and not is_on_floor():
			pass
	
	if Input.is_action_just_released("jump") and not is_on_floor() and velocity.y < 0:
		faster_fall = true
	
	if Input.is_action_just_pressed("action") and velocity.x and not dash_cooldown_timer.time_left:
		dash = true
	
	ducking = Input.is_action_pressed("duck")
	if ducking:
		print("duck")


func apply_movement(delta) -> void:
	if direction.x:
		velocity.x = move_toward(velocity.x, direction.x * speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, acceleration * delta)
	
	if jump or jump_buffer.time_left and is_on_floor():
		velocity.y = -jump_strength
		jump = false
		faster_fall = false
	
	var on_floor: bool = is_on_floor()
	
	move_and_slide()
	
	if on_floor and not is_on_floor() and velocity.y >= 0:
		coyote.start()
	
	# dash
	if dash:
		dash = false
		var dash_tween = create_tween()
		dash_tween.tween_property(self, 'velocity:x', velocity.x + direction.x * 600, 0.3)
		dash_tween.connect("finished", on_dash_finished)
		gravity_multiplier = 0
		dash_cooldown_timer.start()


func on_dash_finished():
	velocity.x = move_toward(velocity.x, 0, 500)
	gravity_multiplier = 1


func apply_gravity(delta) -> void:
	velocity.y += gravity * delta
	velocity.y = velocity.y / 2 if faster_fall and velocity.y < 0 else velocity.y
	velocity.y = velocity.y * gravity_multiplier
	velocity.y = min(velocity.y, terminal_velocity)
