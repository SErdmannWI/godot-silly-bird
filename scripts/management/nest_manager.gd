# NestManager is responsible for maintaining a Dictionary containing all nests.
# It handles egg adding/ removal and collecting info for each nest

class_name NestManager
extends Node

var all_nests: Dictionary


func _init() -> void:
	all_nests = {}


# Check if nest already exists. If it does, return error message. Otherwise, build nest and return success message
func add_nest(location_name: String) -> String:
	if all_nests.has(location_name):
		return "%s already has nest!" % location_name
	
	var nest: Nest = Nest.new(location_name)
	all_nests[location_name] = nest
	
	add_child(nest)
	
	return "Nest built in %s" % location_name


func get_nest(location_name: String) -> Nest:
	return all_nests[location_name]


func location_has_nest(location_name: String) -> bool:
	return all_nests.has(location_name)


# Check if nest exists. If it does, add eggs and return total eggs. Otherwise, return -1
# If nest is at capacity, return -2
func add_egg(location_name: String, bird_type: String) -> int:
	if !all_nests.has(location_name):
		return -1
		
	var nest: Nest = all_nests[location_name]
	
	if nest.nest_at_capacity():
		return -2
	
	nest.add_egg(bird_type, location_name)
	
	return nest.get_total_eggs()


# Check if nest exists. If it does, add eggs and return total eggs. Otherwise, return -1
func remove_egg(location_name, egg_id) -> int:
	if !all_nests.has(location_name):
		return -1
	
	var nest: Nest = all_nests[location_name]
	
	return nest.remove_egg(egg_id)


func damage_nest(location_name: String, amount: int) -> int:
	if !all_nests.has(location_name):
		return -1
	
	var nest: Nest = all_nests[location_name]
	
	return nest.damage_nest(amount)


func repair_nest(location_name: String, amount: int) -> int:
	if !all_nests.has(location_name):
		return -1
	
	var nest: Nest = all_nests[location_name]
	return nest.repair_nest(amount)


func get_total_eggs(location_name: String) -> int:
	if !all_nests.has(location_name):
		return -1
	
	var current_nest: Nest = all_nests[location_name]
	
	return current_nest.get_total_eggs()


func get_nest_info(location_name: String) -> Dictionary:
	var current_nest: Nest = all_nests[location_name]
	
	return current_nest.get_nest_info()


func _on_egg_hatched(egg_id: String) -> void:
	pass
