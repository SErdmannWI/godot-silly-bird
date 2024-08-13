class_name PlayerBird
extends Node

signal hunger_changed(hunger: int)
signal energy_changed(energy: int)
signal social_changed(social: int)
signal mood_changed(mood: String)
signal status_changed(status: String)

#@onready var inventory: Inventory = Inventory.new()
var hunger_timer: Timer
var social_timer: Timer

var bird_name: String
var bird_id: String
var bird_image: Texture
var bird_age: int
var bird_level: int
var bird_experience: int
var bird_behavior: BirdBehavior
var food_type: FoodType

# Bird needs
var hunger: int
var energy: int
var social: int
var mood: String

# Daily stats
var daily_experience: int

# Bird status
var is_awake: bool
var is_hidden: bool
# Each Bird Behavior will have a mood boolean if that behavior is not satisfied
# is_happy is true only if all other moods are false
var is_happy: bool
# is_angry will become true if two or more moods is true
var is_angry: bool

var is_hungry: bool
var is_sleepy: bool
var is_lonely: bool
# Behavior specific
var is_ravenous: bool
var is_annoyed: bool
var is_bored: bool


func _init():
	# Replace this with load player bird once implemented
	_apply_default_properties()


func _ready():
	hunger_timer = Timer.new()
	social_timer = Timer.new()
	add_child(hunger_timer)
	add_child(social_timer)
	
	hunger_timer.timeout.connect(_on_hunger_timer_timeout)
	social_timer.timeout.connect(_on_social_timer_timeout)
	
	_set_timers()
	_mood_check()
	_emit_all()


# Run at the beginning of each day to reset stats/ mood
func start_day():
	is_awake = true
	bird_age += 1
	daily_experience = 0
	energy = 100
	hunger = 100
	social = 100
	
	_mood_check()
	_start_timers()


func end_day():
	_stop_timers()
	_apply_xp()

func get_status() -> String:
	if is_awake:
		return BirdGlobals.STATUS_AWAKE
	
	return BirdGlobals.STATUS_SLEEPING


func get_mood() -> String:
	return _mood_check()


# Action functions
# TODO in future, energy cost will be calculated from environment/ bird abilities
func get_food() -> void:
	if is_hidden:
		# TODO Send signal for UI message
		print("Cannot get food while hidden.")
		return
	
	if energy >= 10:
		energy -= 10
		hunger += 10
		
		hunger_changed.emit(hunger)
		energy_changed.emit(energy)
		
		_hunger_mood_check()
		_mood_check()
		
	else:
		# TODO Send signal for UI message
		print("Not enough energy")


# TODO In future, get social interactions from environment/ bird abilities
func socialize() -> void:
	if is_hidden:
		# TODO Send signal for UI message
		print("Cannot socialize while hidden.")
		return
	
	if energy >= 10:
		energy -= 10
		social += 10
		
		social_changed.emit(social)
		energy_changed.emit(energy)
		
		_social_mood_check()
		_mood_check()
		
	else:
		# TODO Send signal for UI message
		print("Not enough energy")


# TODO: Implement explore function in locations
func explore_area() -> void:
	print("Not implemented")


func hide():
	is_hidden = true


func emerge() -> void:
	is_hidden = false


# First, check anger, then check each of the behavior-specific moods, then normal moods
# returns mood: String
func _mood_check() -> String:
	_anger_check()
	if is_angry:
		mood = BirdGlobals.MOOD_ANGRY
	elif is_ravenous:
		mood = BirdGlobals.MOOD_RAVENOUS
	elif is_annoyed:
		mood = BirdGlobals.MOOD_ANNOYED
	elif is_bored:
		mood = BirdGlobals.MOOD_BORED
	elif is_hungry:
		mood = BirdGlobals.MOOD_HUNGRY
	elif is_sleepy:
		mood = BirdGlobals.MOOD_SLEEPY
	elif is_lonely:
		mood = BirdGlobals.MOOD_LONELY
	else:
		mood = BirdGlobals.MOOD_HAPPY
	
	mood_changed.emit(mood)
	
	return mood


func _hunger_mood_check() -> void:
	if hunger > 30:
		is_hungry = false
	else:
		is_hungry = true

func _social_mood_check() -> void:
	if social > 30:
		is_lonely = false
	else:
		is_lonely = true


func _anger_check() -> void:
	var bad_moods: Array = [is_hungry, is_ravenous, is_annoyed, is_lonely, is_bored, is_sleepy]
	var active_moods: int = 0
	
	for bad_mood in bad_moods:
		if bad_mood:
			active_moods += 1
	
	is_angry = active_moods >= 2


func _on_hunger_timer_timeout() -> void:
	if hunger - 10 > 0:
		hunger -= 10
	else:
		hunger = 0
	
	hunger_changed.emit(hunger)
	
	_hunger_mood_check()
	_mood_check()


func _on_social_timer_timeout() -> void:
	if social - 10 > 0:
		social -= 10
	else:
		social = 0
	
	_social_mood_check()
	social_changed.emit(social)
	_mood_check()


func _apply_xp() -> void:
	bird_experience += daily_experience


# Utility methods
func _emit_all() -> void:
	hunger_changed.emit(hunger)
	social_changed.emit(social)
	energy_changed.emit(energy)
	status_changed.emit(get_status())


func _set_timers() -> void:
	hunger_timer.wait_time = BirdGlobals.HUNGER_TIME
	social_timer.wait_time = BirdGlobals.SOCIAL_TIME
	
	match bird_behavior.name:
		BirdGlobals.BEHAVIOR_RAVENOUS:
			hunger_timer.wait_time = BirdGlobals.RAVENOUS_HUNGER_TIME
		BirdGlobals.BEHAVIOR_SOLITARY:
			social_timer.wait_time = BirdGlobals.SOLITARY_SOCIAL_TIME
	
	hunger_timer.autostart = false
	social_timer.autostart = false


func _start_timers() -> void:
	hunger_timer.start()
	social_timer.start()


func _stop_timers() -> void:
	hunger_timer.stop()
	social_timer.stop()


func _apply_default_properties() -> void:
	bird_name = BirdGlobals.BIRD_TYPE_MOURNING_DOVE
	bird_id = "Test ID"
	bird_image = preload(FilePaths.IMAGE_BIRD_MOURNING_DOVE)
	bird_age = 0
	bird_experience = 0
	bird_level = 0
	bird_behavior = BirdGlobals.BEHAVIOR_PLAYFUL
	food_type = BirdGlobals.FOOD_TYPE_FISH
	hunger = 100
	energy = 100
	social = 100


# Save/ load data
func save_player_data() -> void:
	var _player_data = {
		"bird_name": bird_name,
		"bird_id": bird_id,
		"bird_age": bird_age,
		"bird_level": bird_level,
		"bird_experience": bird_experience,
		"hunger": hunger,
		"energy": energy,
		"social": social
	}
	
	#var json_string: String = JSON.stringify(player_data)
	# TODO: Send to backend save via HTTP Request


# HTTP request will send deserialized JSON here
func load_player_data(player_data: Dictionary) -> void:
	bird_name = player_data["bird_name"]
	bird_id = player_data["bird_id"]
	bird_age = player_data["bird_age"]
	bird_level = player_data["bird_level"]
	bird_experience = player_data["bird_experience"]
	hunger = player_data["hunger"]
	energy = player_data["energy"]
	social = player_data["social"]
	
