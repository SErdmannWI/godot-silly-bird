class_name IdleState
extends State

# Sibling States- states that the current state can transition to
@export var flapping_state: FlappingState
@export var walking_state: WalkingState
@export var falling_state: FallingState


func enter() -> void:
	super()


func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("move_left") and parent.facing_right:
		parent.scale.x *= -1
		parent.facing_right = false
	
	if Input.is_action_just_pressed("move_right") and not parent.facing_right:
		parent.scale.x *= -1
		parent.facing_right = true
	
	if Input.is_action_just_pressed("flap"):
		return flapping_state
	
	if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right"):
		return walking_state
	
	return null


func process_physics(delta: float) -> State:
	if abs(parent.velocity.x) > 0:
		return walking_state
	parent.velocity.y += gravity * delta * gravity_multiplier
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return falling_state
	
	return null
