class_name LocationManager
extends Node

var current_location: Location
var all_locations: Array[Location] = []

signal location_changed(new_location: Location)
signal location_updated(current_location: Location)


func _init():
	all_locations = [
	preload("res://resources/locations/meadow.tres"),
	preload("res://resources/locations/marsh.tres"),
	preload("res://resources/locations/woods.tres")
]
	current_location = all_locations[0]


# Set current location to Meadow
func _ready():
	current_location = all_locations[0]


func start_new_day() -> void:
	pass


func end_day() -> void:
	print("Location Manager: ending day.")


func change_location(location_name: String):
	var new_location: Location = _get_location_by_name(location_name)
	current_location = new_location
	location_changed.emit(new_location)


func get_current_location_name() -> String:
	return current_location.location_name


func _get_location_by_name(location_name: String) -> Location:
	for location in all_locations:
		if location.location_name == location_name:
			return location
		
	return null


func get_nesting_material_needed() -> int:
	return current_location.nest_material_needed
