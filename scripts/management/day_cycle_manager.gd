# Class is responsible for tracking and updating variables that are reset after each day

class_name DayCycleManager
extends Node

signal increment_time(cycles: int, time_of_day: int)

var cycles: int
var time_of_day: int
var timer: Timer = Timer.new()


func _ready() -> void:
	add_child(timer)
	timer.stop()
	timer.timeout.connect(_on_timer_timeout)
	time_of_day = GameGlobals.DayNightCycle.MORNING


func start_new_day() -> void:
	cycles = 0
	timer.start(GameGlobals.TIME_CYCLE_INCREMENT)


func end_day() -> void:
	print("Day Cycle Manager: ending day.")
	timer.stop()


func _on_timer_timeout() -> void:
	cycles += 1
	_set_time_of_day()
	increment_time.emit(cycles, time_of_day)


func _set_time_of_day() -> int:
	if cycles < 75:
		time_of_day = GameGlobals.DayNightCycle.MORNING
	elif cycles >= 75 && cycles <= 225:
		time_of_day = GameGlobals.DayNightCycle.DAY
	elif cycles > 225 && cycles <= 300:
		time_of_day = GameGlobals.DayNightCycle.EVENING
	else:
		time_of_day = GameGlobals.DayNightCycle.NIGHT
	
	return time_of_day
