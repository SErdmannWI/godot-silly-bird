class_name FallingState
extends State

@export var flapping_state: FlappingState
@export var idle_state: IdleState
@export var gliding_state: GlidingState
@export var hovering_state: HoveringState
@export var landing_state: LandingState


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
	
	if Input.is_action_just_pressed("glide"):
		return gliding_state
	
	if Input.is_action_just_pressed("hover"):
		return hovering_state
	
	if Input.is_action_just_pressed("land"):
		if parent.near_landable_surface:
			return landing_state
	
	return null


func process_physics(delta: float) -> State:
	# Apply Gravity
	parent.velocity.y += gravity * delta * gravity_multiplier
	
	var movement = Input.get_axis("move_left", "move_right")
	parent.velocity.x = move_toward(parent.velocity.x, movement * speed, acceleration * 5 * delta)
	
	parent.move_and_slide()
	
	if parent.is_on_floor():
		return idle_state
	
	return null
