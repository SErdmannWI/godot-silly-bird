# Class is responsible for tracking and updating variables that are reset after each day

class_name DayCycleManager
extends Node

signal increment_time(cycles: int, time_of_day: int)
signal temperature_changed(current_temp: int)

var cycles: int
var time_of_day: int
var timer: Timer = Timer.new()

var temperature: int
var temperature_fluctuation: float = 4.0


func _init() -> void:
	pass


func _ready() -> void:
	timer.stop()
	timer.one_shot = false
	timer.timeout.connect(_on_timer_timeout)
	time_of_day = GameGlobals.DayNightCycle.MORNING
	add_child(timer)


func start_new_day() -> void:
	cycles = 0
	timer.start(GameGlobals.TIME_CYCLE_INCREMENT)
	_calculate_temperature()


func end_day() -> void:
	timer.stop()


func _on_timer_timeout() -> void:
	cycles += 1
	_set_time_of_day()
	
	if cycles % 5 == 0:
		_calculate_temperature()
	
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


func get_current_temp() -> int:
	var current_temp: int = temperature
	
	return current_temp


func _calculate_temperature() -> void:
	temperature = _get_interpolated_temperature(cycles)
	temperature_changed.emit(get_current_temp())


func _get_interpolated_temperature(cycle: int) -> int:
	var interpolated_temp: int
	var daily_variation: int
	
	var keys = GameGlobals.SUNNY_TEMPERATURE_DICTIONARY.keys()
	keys.sort()
	
	var lower_cycle = 0
	var upper_cycle = 0
	var lower_temp = 0
	var higher_temp = 0
	
	for i in range(len(keys)) :
		if cycle < int(keys[i]) :
			upper_cycle = int(keys[i])
			lower_cycle = int(keys[i - 1])
			higher_temp = GameGlobals.SUNNY_TEMPERATURE_DICTIONARY[upper_cycle]
			lower_temp = GameGlobals.SUNNY_TEMPERATURE_DICTIONARY[lower_cycle]
			break
	
	var t = float(cycle - lower_cycle) / float(upper_cycle - lower_cycle)
	interpolated_temp = lower_temp + (higher_temp - lower_temp) * t
	
	daily_variation = randf_range(-temperature_fluctuation, temperature_fluctuation)
	
	return int(interpolated_temp + daily_variation)
