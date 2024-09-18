# Flying physics for bird

extends CharacterBody2D

# UI- CanvasLayer assigned as child to camera node
var ui

# Ground movement
@export_group('move')
@export var speed: int = 300
@export var acceleration: int = 600
@export var friction: int = 1000

# Flight movement
@export_group('flight')
@export var flap_strength: int = 50
@export var max_ascent_speed: int = 400
@export var max_descent_speed: int = 500
@export var hover_meter_max: int = 100

# Physics components
var direction: Vector2 = Vector2.ZERO
var fly_strength: int = 0
var gravity: int = 1000
var gravity_multiplier: float = 1.00
var terminal_velocity: int = 500

# Abilities
var flap: bool = false
var glide: bool = false
var can_hover: bool = true
var hover: bool = false
var hover_meter: int = 100


@onready var player_sprite: Sprite2D = %Sprite2D
@onready var flap_cooldown: Timer = %FlapCooldown
@onready var camera: Camera2D = %Camera2D


# Get UI node from camera
func _ready() -> void:
	ui = camera.get_child(0)


# Get Player input, apply lateral movement, apply flight movement, restore abilities
func _process(delta) -> void:
	get_input(delta)
	apply_movement(delta)
	apply_gravity(delta)
	restore_meters()


func get_input(delta) -> void:
	direction.x = Input.get_axis("move_left", "move_right")
	
	# TODO- manage through animations
	# Flip Bird Sprite- flip x scale based on movement choice
	if Input.is_action_just_pressed("move_left"):
		scale.x *= -1
	elif Input.is_action_just_pressed("move_right"):
		scale.x *= -1
	
	if Input.is_action_just_pressed("flap") and not flap_cooldown.time_left and not glide:
		flap = true
		fly_strength += flap_strength
		flap_cooldown.start()
	
	if Input.is_action_pressed("glide") and not is_on_floor() and velocity.y and not flap_cooldown.time_left and not flap and not hover:
		glide = true
	
	if Input.is_action_just_released("glide"):
		glide = false
	
	# Hover meter must be fully recovered before bird can hover again
	if Input.is_action_pressed("hover") and can_hover and not glide and not is_on_floor():
		if hover_meter:
			hover_meter -= 1
			hover = true
		else:
			hover = false
			can_hover = false
		
		ui.update_hover_meter(hover_meter)
	
	if Input.is_action_just_released("hover"):
		hover = false


func apply_movement(delta) -> void:
	if direction.x != 0 and not hover:
		velocity.x = move_toward(velocity.x, direction.x * speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, acceleration * delta)
	
	move_and_slide()
	
	# glide
	if glide:
		gravity_multiplier = 0.25
	elif not glide and not hover:
		gravity_multiplier = 1.00


func apply_gravity(delta) -> void:
	if hover and velocity.y > 0:
		gravity_multiplier = max(gravity_multiplier - 0.1, 0)
	velocity.y += gravity * delta * gravity_multiplier
	
	if flap:
		velocity.y = min(velocity.y - fly_strength * delta, -max_ascent_speed)
		flap = false
	
	
	if fly_strength:
		fly_strength -= 50


func restore_meters() -> void:
	if not hover and hover_meter < hover_meter_max:
		hover_meter += 1
	elif hover_meter == hover_meter_max:
		can_hover = true
	
	ui.update_hover_meter(hover_meter)
