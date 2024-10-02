class_name WalkingState
extends State

@export var idle_state: IdleState
@export var falling_state: FallingState
@export var flapping_state: FlappingState


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
	
	return null


func process_physics(delta: float) -> State:
	# Apply Gravity
	parent.velocity.y += gravity * delta * gravity_multiplier
	
		#if direction.x != 0 and not hover:
		#velocity.x = move_toward(velocity.x, direction.x * speed, acceleration * delta)
	#else:
		#velocity.x = move_toward(velocity.x, 0, acceleration * delta)
	
	var movement = Input.get_axis("move_left", "move_right")
	if movement == 0:
		parent.velocity.x = move_toward(parent.velocity.x, movement * speed, acceleration * friction * delta)
	else:
		parent.velocity.x = move_toward(parent.velocity.x, movement * speed, acceleration * delta)
	
	parent.move_and_slide()
	
	if parent.velocity.x == 0:
		return idle_state
	
	return null
