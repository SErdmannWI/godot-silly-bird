# Nest maintains any eggs contained inside.
# Signals from Egg events (e.g. hatched) are sent here and reported up to Director

class_name Nest
extends Node

# Signals UI changes to Director
signal egg_added(egg_info: Dictionary, total_eggs: int)


var location_name: String
var type: String = "Bowl Nest"
var level: int = 1
var upgrades: String = "No Upgrades"
var status: String = "Healthy"
var eggs: Dictionary = {}
var egg_numbers: Array[int] = [0, 1, 2, 3, 4, 5]
var nest_capacity: int = 2
var _hp: int = 10
var _hp_max: int = 10


func _init(location: String) -> void:
	location_name = location


################################################################################
################################ Egg Functions #################################
################################################################################

func get_eggs() -> Dictionary:
	return eggs


# Gets type of Bird and location of Nest, assigns ID from unused ID number and location name
# Egg ID = Location name and position in the nest (egg_number) (e.g. first egg in Meandow = Meadow_0)
func add_egg(egg_type: String, egg_location: String) -> Egg:
	var egg_number: int
	
	if eggs.keys().is_empty():
		egg_number = 0
	
	else:
		for number in egg_numbers:
			
			# find first available sequentially
			if !eggs.keys().has(egg_location + "_" + str(number)):
				egg_number = number
				break
	
	# Create Egg, connect hatched signal
	var new_egg: Egg = EggFactory.create_egg(egg_type, egg_location, egg_number)
	eggs[new_egg.egg_id] = new_egg
	add_child(new_egg)
	
	var egg_info: Dictionary = new_egg.get_egg_info()
	egg_added.emit(egg_info, get_total_eggs()) # -> Director
	
	return new_egg


# Called by NestManager as result of (hatched, broken)
# Remove child and then remove stored instance in egg array
func remove_egg(egg_id: String) -> void:
	for child: Egg in get_children() :
		if (child.egg_id == egg_id) :
			child.queue_free()
	eggs.erase(egg_id)


func get_all_egg_info() -> Array[Dictionary]:
	var all_eggs_info: Array[Dictionary] = []
	
	for egg in eggs:
		all_eggs_info.append(eggs[egg].get_egg_info())
	
	return all_eggs_info


func get_total_eggs() -> int:
	return eggs.keys().size()


################################################################################
############################### Nest Functions #################################
################################################################################

func repair_nest(amount: int) -> int:
	if _hp + amount >= _hp_max:
		_hp = _hp_max
	
	else:
		_hp += amount
	
	return get_hp()


func damage_nest(amount: int) -> int:
	if _hp - amount <= 0:
		_hp = 0
	
	else:
		_hp -= amount
	
	return get_hp()


func get_hp() -> int:
	return _hp


func get_max_hp() -> int:
	return _hp_max


func get_nest_info() -> Dictionary:
	var nest_info: Dictionary = {}
	
	nest_info[NestGlobals.NEST_LOCATION_NAME] = location_name
	nest_info[NestGlobals.NEST_LEVEL] = level
	nest_info[NestGlobals.NEST_TYPE] = type
	nest_info[NestGlobals.NEST_UPGRADES] = upgrades
	nest_info[NestGlobals.NEST_STATUS] = status
	nest_info[NestGlobals.NEST_CAPACTIY] = nest_capacity
	nest_info[NestGlobals.NEST_EGGS] = get_all_egg_info().duplicate(true)
	nest_info[NestGlobals.NEST_HP] = get_hp()
	nest_info[NestGlobals.NEST_MAX_HP] = get_max_hp()
	
	return nest_info


func set_nest_capactiy(new_value: int) -> int:
	nest_capacity = new_value
	return nest_capacity


func nest_at_capacity() -> bool:
	if get_total_eggs() == nest_capacity:
		return true
	
	return false


func resume_all_incubation() -> void:
	for egg: Egg in get_children():
		egg.resume_incubation()


func pause_all_incubation() -> void:
	for egg: Egg in get_children():
		egg.pause_incubation()
