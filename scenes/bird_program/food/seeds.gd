extends Node2D

signal player_nearby(item_id)

var item_scene: PackedScene = preload(FilePaths.SCENE_FOOD_SEED)

var action: Action

var item_id: String = "SeedMed"
var item_name: String = "Medium Seed Cluster"
var can_pickup: bool = false

@onready var label_prompt: Label = %ButtonPromptLabel

func _ready() -> void:
	label_prompt.visible = false
	action = FoodAction.new(self, true, item_id, false)


func _on_player_body_entered(body) -> void:
	if (body.has_method("perform_action")):
		label_prompt.visible = true
		can_pickup = true
		Director.add_to_action_queue(action)


func _on_player_body_exited(body) -> void:
	if (body.has_method("perform_action")):
		label_prompt.visible = false
		can_pickup = false
		Director.remove_from_action_queue(action.action_id)

