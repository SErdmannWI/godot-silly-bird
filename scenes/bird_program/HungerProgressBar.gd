extends ProgressBar

signal high_hunger
signal satiated

var is_sleeping:bool


func _ready():
	is_sleeping = false


func _check_hunger_level():
	if value < 33:
		high_hunger.emit()
	else:
		satiated.emit()


func on_sleep_toggle():
	if is_sleeping:
		is_sleeping = false
	else:
		is_sleeping = true

func on_hunger_timer_timout():
	if is_sleeping:
		decrement_hunger_need_sleeping()
	else:
		decrement_hunger_need()

func decrement_hunger_need_sleeping():
	value -= 1
	_check_hunger_level()

func decrement_hunger_need():
	value -= 2
	_check_hunger_level()

func increment_hunger_need():
	value += 10
	_check_hunger_level()

# Debug functions
func on_debug_signal(amount:int) -> void:
	value -= amount
	_check_hunger_level()

func decrease_hunger_10():
	value -= 10
	_check_hunger_level()

func decrease_hunger_100():
	value -= 100
	_check_hunger_level()
