# Flying physics for bird
extends CharacterBody2D

signal action_pressed

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

# Sprite aspects
var facing_right: bool = false

# Abilities
var flap: bool = false
var glide: bool = false
var can_hover: bool = true
var hover: bool = false
var hover_meter: int = 100
var landing: bool = false
var landed: bool = false

# Environment Interactions
var near_item: bool = false
var near_landable_surface: bool = false


@onready var player_sprite: Sprite2D = %Sprite2D
@onready var flap_cooldown: Timer = %FlapCooldown
@onready var landed_cooldown: Timer = %LandedCooldown
@onready var camera: Camera2D = %Camera2D
@onready var ui: Node2D = %BirdUI
@onready var non_physics_area_2d: Area2D = %NonPhysicsArea2D


func _ready() -> void:
	non_physics_area_2d.body_entered.connect(display_prompt)
	non_physics_area_2d.body_exited.connect(hide_prompt)


# Get Player input, apply lateral movement, apply flight movement, restore abilities
func _process(delta) -> void:
	_get_input(delta)
	_apply_movement(delta)
	_apply_gravity(delta)
	_restore_meters()
	_check_collisions()

# Inputs except for "flap" are frozen while the Player is landed
# If Player is landing, landing physics take over until landed and cooldown after landing is done
func _get_input(delta) -> void:
	if !landed:
		if not landing and not landed_cooldown.time_left:
			direction.x = Input.get_axis("move_left", "move_right")
			
			# TODO- manage through animations
			if Input.is_action_just_pressed("move_left"):
				if facing_right:
					scale.x *= -1
				facing_right = false
			elif Input.is_action_just_pressed("move_right"):
				if not facing_right:
					scale.x *= -1
				facing_right = true
			
			if Input.is_action_just_pressed("flap") and not flap_cooldown.time_left and not glide:
				flap = true
				fly_strength += flap_strength
				flap_cooldown.start()
			
			if Input.is_action_pressed("glide") and not is_on_floor() and velocity.y and not flap_cooldown.time_left and not flap and not hover and not landed:
				glide = true
			
			if Input.is_action_just_released("glide"):
				glide = false
			
			# Hover meter must be fully recovered before bird can hover again
			if Input.is_action_pressed("hover") and can_hover and not glide and not is_on_floor() and not landed:
				if hover_meter:
					hover_meter -= 1
					hover = true
				else:
					hover = false
					can_hover = false
				
				ui.update_hover_meter(hover_meter)
			
			if Input.is_action_just_released("hover"):
				hover = false
			
			if Input.is_action_just_pressed("action"):
				perform_action()
			
			if Input.is_action_just_pressed("Land"):
				if near_landable_surface:
					land_bird()
	elif landed:
		if Input.is_action_just_pressed("flap"):
			landed = false
			hide_prompt()
			flap = true
			fly_strength += flap_strength
			flap_cooldown.start()
	else:
		direction.x = 0
		direction.y = 0


func _apply_movement(delta) -> void:
	if not near_landable_surface:
		landing = false
	
	if landing:
		# Increase deceleration rate for landing
		var landing_deceleration: int = 3000
		velocity.x = move_toward(velocity.x, 0, landing_deceleration * delta)
		velocity.y = move_toward(velocity.y, 0, landing_deceleration * delta)
		
		# Check if bird has come to complete stop
		if abs(velocity.x) < 1 and abs(velocity.y) < 1:
			velocity = Vector2.ZERO
			landing = false
			_bird_is_landed()
	
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


func _apply_gravity(delta) -> void:
	if not landed:
		if hover and velocity.y > 0:
			gravity_multiplier = max(gravity_multiplier - 0.1, 0)
		velocity.y += gravity * delta * gravity_multiplier
		
		if flap:
			velocity.y = min(velocity.y - fly_strength * delta, -max_ascent_speed)
			flap = false
		
		if fly_strength:
			fly_strength -= 50
	else:
		pass


func land_bird() -> void:
	landing = true


func _bird_is_landed() -> void:
	landing = false
	hover = false
	glide = false
	landed = true
	landed_cooldown.start()
	display_prompt(null, "Press Space to Fly")


func perform_action() -> void:
	Director.perform_next_action()

# If player is not in an area where they can land or perform another action, hide the prompt
func _check_collisions() -> void:
	if not non_physics_area_2d.has_overlapping_bodies():
		hide_prompt()


# UI functions
func _restore_meters() -> void:
	if not hover and hover_meter < hover_meter_max:
		hover_meter += 1
	elif hover_meter == hover_meter_max:
		can_hover = true
	
	ui.update_hover_meter(hover_meter)


func display_prompt(body: Node2D, message: String = "") -> void:
	if body != null:
		near_landable_surface = true
		ui.update_player_prompt("Press F to Land")
	elif body == null and message:
		ui.update_player_prompt(message)


func hide_prompt(body = null) -> void:
	near_landable_surface = false
	ui.hide_player_prompt()

