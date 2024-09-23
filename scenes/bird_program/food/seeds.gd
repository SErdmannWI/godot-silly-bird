extends Node2D

@onready var label_prompt: Label = %ButtonPromptLabel

func _ready() -> void:
	label_prompt.visible = false

func _on_player_body_entered(_body) -> void:
	label_prompt.visible = true

func _on_player_body_exited(_body) -> void:
	label_prompt.visible = false
