extends ProgressBar

signal low_energy
signal optimal_energy

var is_sleeping:bool

func _ready():
	is_sleeping = false


func _check_energy_level():
	if value < 33:
		low_energy.emit()
	else:
		optimal_energy.emit()

func on_sleep_toggle():
	if is_sleeping:
		is_sleeping = false
	else:
		is_sleeping = true

func on_energy_timer_timeout():
	if is_sleeping:
		increment_energy_need()
	else:
		decrement_energy_need()

func decrement_energy_need():
	value -= 1
	_check_energy_level()

func increment_energy_need():
	value += 10
	_check_energy_level()


# Debug functions
func on_debug_signal(amount:int) -> void:
	value -= amount
	_check_energy_level()

func decrease_energy_10():
	value -= 10
	_check_energy_level()

func decrease_energy_100():
	value -= 100
	_check_energy_level()
