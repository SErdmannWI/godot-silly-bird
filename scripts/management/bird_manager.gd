# BirdManager is responsible for getting bird info and triggering bird actions. Signals bypass the
# Manager and are reported to the Director


class_name BirdManager
extends Node

var bird : PlayerBird

#func _init():
	## TODO Replace assignment to actual Player bird when implemented
	#bird = PlayerBird.new()


func _ready():
	_create_bird()


func _create_bird():
	bird = PlayerBird.new()
	add_child(bird)

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
	bird_data[BirdGlobals.BIRD_DAILY_EXPERIENCE_KEY] = bird.daily_experience
	
	return bird_data


func start_bird_day() -> void:
	bird.start_day()


func give_food() -> void:
	bird.get_food()


func end_day() -> void:
	bird.end_day()


#func give_nest(nest: Nest) -> void:
	#bird.nest = nest
#
#
#func lay_eggs(amount: int) -> void:
	#Director.add_eggs(amount)
#
#
#func repair_nest(amount: int) -> void:
	#Director.repair_nest(amount)
#
#
#func can_build_nest(material_needed: int) -> bool:
	#return bird.can_build_nest(material_needed)
