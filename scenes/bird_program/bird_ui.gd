extends Node2D

@onready var hover_meter: ProgressBar = %HoverMeter


func update_hover_meter(amount: int) -> void:
	hover_meter.value = amount
