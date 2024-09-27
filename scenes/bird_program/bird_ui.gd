extends Node2D

# Labels
@onready var temperature_label: Label = %TemperatureLabel


# Environment Meters
@onready var clock: TextureRect = %ClockfaceTextureRect
@onready var thermometer: TextureRect = %Thermometer

# Progress Bars
@onready var hunger_progress_bar: ProgressBar = %HungerProgressBar
@onready var social_progress_bar: ProgressBar = %SocialProgressBar
@onready var energy_progress_bar: ProgressBar = %EnergyProgressBar
@onready var hover_meter: ProgressBar = %HoverMeter


func _ready() -> void:
	_connect_to_director()


func _process(delta) -> void:
	pass


func _connect_to_director() -> void:
	# Bird signals
	Director.update_hunger.connect(_on_hunger_changed)
	Director.update_social.connect(_on_social_changed)
	Director.update_energy.connect(_on_energy_changed)
	Director.update_mood.connect(_on_mood_changed)
	Director.update_status.connect(_on_status_changed)
	# Egg signals
	Director.egg_info_changed.connect(_on_egg_info_updated)
	Director.egg_added.connect(_on_egg_added)
	Director.egg_progressed.connect(_on_egg_progress)
	# Nest signals
	Director.nest_info_changed.connect(_on_nest_updated)
	Director.current_nest_info_changed.connect(_on_current_nest_updated)
	# Day Cycle/ Weather signals
	Director.update_temp.connect(_on_temperature_changed)
	Director.update_time.connect(_on_time_cycle_increment)


# Update Environment Meters
func _on_temperature_changed(current_temp: int) -> void:
	thermometer.on_temperature_changed(current_temp)
	temperature_label.text = "%d F" % current_temp


func _on_time_cycle_increment(cycles: int, time_of_day: int) -> void:
	clock.on_time_incremented(cycles)


# Update Bird Meters
func _on_hunger_changed(hunger: int) -> void:
	hunger_progress_bar.value = hunger


func _on_social_changed(social: int) -> void:
	social_progress_bar.value = social


func _on_energy_changed(energy: int) -> void:
	energy_progress_bar.value = energy


func update_hover_meter(amount: int) -> void:
	hover_meter.value = amount


# Update Bird Status- currently unused
func _on_mood_changed(mood: String) -> void:
	print("Bird mood: %d" % mood)


func _on_status_changed(status: String) -> void:
	print("Bird status: %d" % status)


# TODO Update Nest
func _on_egg_info_updated(egg_info: Dictionary, total_eggs: int) -> void:
	pass


func _on_egg_added(egg_info: Dictionary, total_eggs: int) -> void:
	pass


func _on_egg_progress(egg_progress: Dictionary) -> void:
	pass


func _on_nest_updated(nest_info: Dictionary, status_code: int) -> void:
	pass


func _on_current_nest_updated(nest_info: Dictionary, status_code: int) -> void:
	pass
