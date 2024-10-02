class_name PlayerStateMachine
extends Node

@export var starting_state: State

var player: TestPlayerBirdAvatar
var current_state: State

@onready var flap_cooldown: Timer = %FlapCooldown
@onready var landed_cooldown: Timer = %LandedCooldown


func init(parent: TestPlayerBirdAvatar) -> void:
	player = parent
	
	for child: State in get_children():
		child.parent = get_parent()
	
	change_state(starting_state)


func change_state(new_state: State) -> void:
	if current_state:
		current_state.exit()
	
	current_state = new_state
	current_state.enter()


func process_input(event: InputEvent) -> void:
	var new_state = current_state.process_input(event)
	
	if new_state:
		change_state(new_state)


func process_physics(delta: float) -> void:
	var new_state = current_state.process_physics(delta)
	
	if new_state:
		change_state(new_state)


func process_frame(delta: float) -> void:
	var new_state = current_state.process_frame(delta)
	
	if new_state:
		change_state(new_state)
	
	_player_property_processing()

# Handles adjusting movement-based properties, such as hover meter
func _player_property_processing() -> void:
	if !player.is_hovering and !player.can_hover:
		player.restore_hover()
