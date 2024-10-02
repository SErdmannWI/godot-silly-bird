class_name HoveringState
extends State

var deceleration: int = 1000

@export var falling_state: FallingState
@export var flapping_state: FlappingState
@export var landing_state: LandingState
@export var idle_state: IdleState


func enter() -> void:
	super()


func process_input(event: InputEvent) -> State:
	if !Input.is_action_pressed("hover"):
		parent.is_hovering = false
		parent.can_hover = false
		return falling_state
	
	if Input.is_action_just_pressed("move_left") and parent.facing_right:
		parent.scale.x *= -1
		parent.facing_right = false
	
	if Input.is_action_just_pressed("move_right") and not parent.facing_right:
		parent.scale.x *= -1
		parent.facing_right = true
	
	if Input.is_action_just_pressed("flap"):
		parent.is_hovering = false
		return flapping_state
	
	if Input.is_action_just_pressed("land"):
		if parent.near_landable_surface:
			parent.is_hovering = false
			return landing_state
	
	return null


func process_physics(delta: float) -> State:
	if not parent.can_hover:
		return falling_state
	
	if parent.hover_meter <= 0:
		parent.is_hovering = false
		return falling_state
	
	if parent.velocity.y < - 50:
		parent.is_hovering = false
		return falling_state
	
	parent.is_hovering = true
	parent.expend_hover()
	# Apply Gravity
	#parent.velocity.y += gravity * gravity_multiplier * delta
	parent.velocity.y = move_toward(parent.velocity.y, 0, deceleration * delta)
	
	parent.velocity.x = move_toward(parent.velocity.x, 0, deceleration * delta)
	
	parent.move_and_slide()
	
	if parent.is_on_floor():
		return idle_state
	
	return null
