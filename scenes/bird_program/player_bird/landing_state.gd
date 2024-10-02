class_name LandingState
extends State

var deceleration: int = 2000

@export var falling_state: FallingState
@export var landed_state: LandedState


func enter() -> void:
	super()


func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("move_left") and parent.facing_right:
		parent.scale.x *= -1
		parent.facing_right = false
	
	if Input.is_action_just_pressed("move_right") and not parent.facing_right:
		parent.scale.x *= -1
		parent.facing_right = true
	
	return null


func process_physics(delta: float) -> State:
	if parent.velocity.y < 1:
		return landed_state
	# Apply Gravity
	#parent.velocity.y += gravity * gravity_multiplier * delta
	parent.velocity.y = move_toward(parent.velocity.y, 0, deceleration * delta)
	
	parent.velocity.x = move_toward(parent.velocity.x, 0, deceleration * delta)
	
	parent.move_and_slide()
	
	return null

