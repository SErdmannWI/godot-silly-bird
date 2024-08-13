extends ProgressBar

signal lonely
signal fulfilled

var is_sleeping:bool

func _ready():
	is_sleeping = false

func _check_social_level():
	if value < 33:
		lonely.emit()
	else:
		fulfilled.emit()

func on_sleep_toggle():
	if is_sleeping:
		is_sleeping = false
	else:
		is_sleeping = true

func on_social_timer_timeout():
	if !is_sleeping:
		decrement_social_need()

func decrement_social_need():
	value -= 1
	_check_social_level()

func increment_social_need():
	value += 10
	_check_social_level()


# Debug functions
func on_debug_signal(amount:int) -> void:
	value -= amount
	_check_social_level()

func decrease_social_10():
	value -= 10
	_check_social_level()

func decrease_social_100():
	value -= 100
	_check_social_level()
