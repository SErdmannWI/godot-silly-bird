extends Node2D

# Labels
@onready var temperature_label: Label = %TemperatureLabel
@onready var prompt_label: Label = %PromptLabel


# Environment Meters
@onready var clock: TextureRect = %ClockfaceTextureRect
@onready var thermometer: TextureRect = %Thermometer

# Progress Bars
@onready var hunger_progress_bar: ProgressBar = %HungerProgressBar
@onready var social_progress_bar: ProgressBar = %SocialProgressBar
@onready var energy_progress_bar: ProgressBar = %EnergyProgressBar
@onready var hover_meter: ProgressBar = %HoverMeter

# Message Center
@onready var hp_label: Label = %DynamicLabel
@onready var mood_label: Label = %DynamicLabel2
@onready var message_type_label: Label = %MessageTypeLabel
@onready var message_label: Label = %MessageLabel



func _ready() -> void:
	_connect_to_director()
	prompt_label.position = Vector2(800,440)


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


# Player prompts
func update_player_prompt(prompt: String) -> void:
	prompt_label.text = prompt
	prompt_label.visible = true


func hide_player_prompt() -> void:
	prompt_label.text = ""
	prompt_label.visible = false


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


func _on_hp_changed(hp: int) -> void:
	var color: Color
	if hp >= 85:
		color = GameGlobals.COLOR_TEXT_BLUE
	elif hp < 85 and hp >= 70:
		color = GameGlobals.COLOR_TEXT_GREEN
	elif hp < 70 and hp >= 30:
		color = GameGlobals.COLOR_TEXT_YELLOW
	else:
		color = GameGlobals.COLOR_TEXT_RED
	
	hp_label.update_text(hp, color)


func _on_mood_changed(mood: String) -> void:
	var color: Color
	
	match(mood):
		BirdGlobals.MOOD_HAPPY:
			color = GameGlobals.COLOR_TEXT_GREEN
		BirdGlobals.MOOD_HUNGRY:
			color = GameGlobals.COLOR_TEXT_YELLOW
		BirdGlobals.MOOD_ANGRY:
			color = GameGlobals.COLOR_TEXT_RED
		BirdGlobals.MOOD_LONELY:
			color = GameGlobals.COLOR_TEXT_BLUE
		_:
			color = GameGlobals.COLOR_TEXT_GREEN
	
	mood_label.update_text(mood, color)


func _on_status_changed(status: String) -> void:
	pass


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
