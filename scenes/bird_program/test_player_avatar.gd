# Flying physics for bird
class_name TestPlayerBirdAvatar
extends CharacterBody2D

signal action_pressed

# Sprite aspects
var facing_right: bool = false
var direction: Vector2 = Vector2.ZERO

var hover_meter: int = 100
var can_hover: bool = true
var is_hovering: bool = false

# Environment Interactions
var near_item: bool = false
var near_landable_surface: bool = false

@onready var player_sprite: Sprite2D = %Sprite2D
@onready var flap_cooldown: Timer = %FlapCooldown
@onready var landed_cooldown: Timer = %LandedCooldown
@onready var camera: Camera2D = %Camera2D
@onready var ui: Node2D = %BirdUI
@onready var non_physics_area_2d: Area2D = %NonPhysicsArea2D
@onready var player_state_machine = %PlayerStateMachine



func _ready() -> void:
	player_state_machine.init(self)
	non_physics_area_2d.body_entered.connect(display_prompt)
	non_physics_area_2d.body_exited.connect(hide_prompt)


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("action"):
		perform_action()
	
	player_state_machine.process_input(event)


func _physics_process(delta: float) -> void:
	player_state_machine.process_physics(delta)


func _process(delta) -> void:
	player_state_machine.process_frame(delta)



func perform_action() -> void:
	Director.perform_next_action()


# If player is not in an area where they can land or perform another action, hide the prompt
func _check_collisions() -> void:
	if not non_physics_area_2d.has_overlapping_bodies():
		hide_prompt()


# UI functions
func expend_hover() -> void:
	if hover_meter > 0:
		hover_meter -= 1
		ui.update_hover_meter(hover_meter)
	else:
		can_hover = false


func restore_hover() -> void:
	if hover_meter < 100:
		hover_meter += 1
		ui.update_hover_meter(hover_meter)
	elif hover_meter == 100:
		can_hover = true


func display_prompt(body: Node2D, message: String = "") -> void:
	if body != null:
		near_landable_surface = true
		ui.update_player_prompt("Press F to Land")
	elif body == null and message:
		ui.update_player_prompt(message)


func hide_prompt(body = null) -> void:
	near_landable_surface = false
	ui.hide_player_prompt()
	
	pass

