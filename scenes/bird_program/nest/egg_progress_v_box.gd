extends VBoxContainer

var _egg_id: String
var _incubation_total_time: int
var _incubation_time_remaining: int

@onready var label_egg: Label = %EggProgressLabel
@onready var progress_bar_egg: ProgressBar = %EggProgressBar

func _ready():
	label_egg.text = _egg_id
	progress_bar_egg.max_value = _incubation_total_time
	progress_bar_egg.value = _incubation_time_remaining


func set_egg_id(new_egg_id: String) -> void:
	_egg_id = new_egg_id


func get_egg_id() -> String:
	return _egg_id


func set_progress_bar_values(total_time: int, current_progress: int) -> void:
	_incubation_total_time = total_time
	_incubation_time_remaining = current_progress
	


func update_progress_bar(current_progress: int) -> void:
	progress_bar_egg.value = current_progress
