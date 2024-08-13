# Class is responsible for tracking and updating variables that are reset after each day

class_name DayCycleManager
extends Node

var _running_xp: int


func _ready() -> void:
	_running_xp = 0


func start_new_day() -> void:
	_running_xp = 0


func get_running_xp() -> int:
	return _running_xp


func increment_xp(amount: int) -> int:
	_running_xp += amount
	
	return _running_xp
