class_name FlappingState
extends State

@export var falling_state: FallingState

@export var flap_strength: int = 50
@export var max_ascent_speed: int = 400

var fly_strength: int = 0

@onready var flap_cooldown: Timer = %FlapCooldown


func enter() -> void:
	super()


func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("move_left") and parent.facing_right:
		parent.scale.x *= -1
		parent.facing_right = false
	
	if Input.is_action_just_pressed("move_right") and not parent.facing_right:
		parent.scale.x *= -1
		parent.facing_right = true
	
	return falling_state


# Flaps cannot be continuous so this will always return falling state
func process_physics(delta: float) -> State:
	if flap_cooldown.time_left:
		return falling_state
	
	fly_strength += flap_strength
	# Apply Gravity
	parent.velocity.y = min(parent.velocity.y - fly_strength * delta, -max_ascent_speed)
	
	parent.velocity.x = move_toward(parent.velocity.x, parent.direction.x * speed, acceleration * delta)
	
	parent.move_and_slide()
	
	flap_cooldown.start()
	
	return falling_state
