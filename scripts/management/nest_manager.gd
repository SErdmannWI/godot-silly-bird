# NestManager is responsible for maintaining a Dictionary containing all nests.
# It handles egg adding/ removal and collecting info for each nest

class_name NestManager
extends Node

# Sent to Director after removing egg
signal egg_hatched(nest_info: Dictionary)
signal egg_broken(nest_info: Dictionary)

var all_nests: Dictionary


func _init() -> void:
	all_nests = {}


func start_new_day() -> void:
	for nest: Nest in get_children():
		nest.resume_all_incubation()


func end_day() -> void:
	print("Nest Manager: ending day.")
	for nest: Nest in get_children():
		nest.pause_all_incubation()


# Build nest and add to Manager. Return nest to Director
func add_nest(location_name: String) -> Nest:
	
	var nest: Nest = Nest.new(location_name)
	all_nests[location_name] = nest
	
	add_child(nest)
	
	return nest


func get_nest(location_name: String) -> Nest:
	return all_nests[location_name]


func location_has_nest(location_name: String) -> bool:
	return all_nests.has(location_name)


################################################################################
################################ Egg Functions #################################
################################################################################

# Called by Director
# Check if nest exists. If it does, add eggs and return total eggs. Otherwise, return NO_NEST
# If nest is at capacity, return NEST_FULL
func add_egg(location_name: String, bird_type: String) -> Array:
	var response: Array = []
	if !all_nests.has(location_name):
		response.append(GameGlobals.ResponseCode.NO_NEST)
		return response
		
	var nest: Nest = all_nests[location_name]
	
	if nest.nest_at_capacity():
		response.append(GameGlobals.ResponseCode.NEST_FULL)
		return response
	
	var new_egg: Egg = nest.add_egg(bird_type, location_name)
	new_egg.hatched.connect(_on_egg_hatched)
	new_egg.broken.connect(_on_egg_broken)
	
	response.append(nest.get_total_eggs())
	response.append(new_egg)
	
	return response


# Called as result of signal from Egg (hatched, broken)
func remove_egg(location_name, egg_id) -> void:
	var nest: Nest = all_nests[location_name]
	nest.remove_egg(egg_id)
	var updatedNestInfo: Dictionary = nest.get_nest_info()


func get_total_eggs(location_name: String) -> int:
	if !all_nests.has(location_name):
		return -1
	
	var current_nest: Nest = all_nests[location_name]
	
	return current_nest.get_total_eggs()


func _on_egg_hatched(egg_id: String) -> void:
	var location_name: String = egg_id.split("_")[0]
	remove_egg(location_name, egg_id)
	egg_hatched.emit(all_nests[location_name].get_nest_info()) # -> Director


func _on_egg_broken(egg_id: String) -> void:
	pass


################################################################################
############################### Nest Functions #################################
################################################################################

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


func get_nest_info(location_name: String) -> Dictionary:
	var current_nest: Nest = all_nests[location_name]
	
	return current_nest.get_nest_info()
