class_name LandedState
extends State

@export var flapping_state: FlappingState


func enter() -> void:
	super()


func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("flap"):
		return flapping_state
	
	if Input.is_action_just_pressed("move_left") and parent.facing_right:
		parent.scale.x *= -1
		parent.facing_right = false
	
	if Input.is_action_just_pressed("move_right") and not parent.facing_right:
		parent.scale.x *= -1
		parent.facing_right = true
	
	return null


func process_physics(delta: float) -> State:
	
	return null
