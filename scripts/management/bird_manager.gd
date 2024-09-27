# BirdManager is responsible for getting bird info and triggering bird actions. Signals bypass the
# Manager and are reported to the Director


class_name BirdManager
extends Node

var bird : PlayerBird

#func _init():
	## TODO Replace assignment to actual Player bird when implemented
	#bird = PlayerBird.new()


func _init():
	_create_bird()


func start_new_day() -> void:
	get_bird_data()
	bird.start_day()


# Called from group call to Managers
func end_day() -> void:
	bird.end_day()


func _create_bird():
	bird = PlayerBird.new()

# Gets key/value for each property of the bird and returns
func get_bird_data() -> Dictionary:
	var bird_data = {}
	
	bird_data[BirdGlobals.BIRD_NAME_KEY] = bird.bird_name
	bird_data[BirdGlobals.BIRD_AGE_KEY] = bird.bird_age
	bird_data[BirdGlobals.BIRD_IMAGE_KEY] = bird.bird_image
	bird_data[BirdGlobals.BIRD_FOOD_TYPE_KEY] = bird.food_type.name
	bird_data[BirdGlobals.BIRD_LEVEL_KEY] = bird.bird_level
	bird_data[BirdGlobals.BIRD_MOOD_KEY] = bird.get_mood()
	bird_data[BirdGlobals.BIRD_STATUS_KEY] = bird.get_status()
	bird_data[BirdGlobals.BIRD_DAILY_EXPERIENCE_KEY] = bird.daily_xp_gained
	bird_data[BirdGlobals.BIRD_TOTAL_EXPERIENCE_KEY] = bird.total_xp
	
	return bird_data


func feed_bird(amount: int) -> void:
	bird.eat(amount)


func add_xp_to_bird(xp_gained: int) -> int:
	return bird.add_daily_xp(xp_gained)
