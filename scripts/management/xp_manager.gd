# Handles leveling up logic for any entity that can level (bird, nest)
# Handles leveling trees

class_name XpManager
extends Node


var _xp_daily_running_total: int


func start_new_day() -> void:
	print("XP Manager: starting new day")
	_reset_xp()


func end_day() -> void:
	print("XP Manager: ending day.")


func check_if_leveled_up(current_level: int, current_xp: int) -> bool:
	var desired_level: int = current_level + 1
	return GameGlobals.XP_LEVELING_THRESHOLDS[desired_level] <= current_xp


func get_xp_running_total() -> int:
	return _xp_daily_running_total


func increment_xp(amount: int) -> int:
	_xp_daily_running_total += amount
	
	return _xp_daily_running_total 


func _reset_xp() -> void:
	_xp_daily_running_total = 0
