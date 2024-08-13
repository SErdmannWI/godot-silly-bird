# Nest maintains any eggs contained inside.
# Signals from Egg events (e.g. hatched) are sent here and reported up to Director

class_name Nest
extends Node

signal egg_added(egg_info: Dictionary, total_eggs: int)
signal egg_removed(egg_info: Dictionary, total_eggs: int)
signal egg_hatched(egg_id: String, location_name: String)

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


func _ready() -> void:
	egg_added.connect(Director.on_egg_added)
	egg_hatched.connect(Director.on_egg_hatched)


# Egg Functions
func get_eggs() -> Dictionary:
	return eggs


func add_egg(egg_type: String, egg_location: String) -> void:
	print("Current Eggs: " + str(eggs.keys()))
	var egg_number: int
	
	if eggs.keys().is_empty():
		egg_number = 0
	
	else:
		for number in egg_numbers:
			
			if !eggs.keys().has(egg_location + "_" + str(number)):
				egg_number = number
				break
				
	var new_egg: Egg = EggFactory.create_egg(egg_type, egg_location, egg_number)
	
	new_egg.egg_hatched.connect(_on_egg_hatched)
	
	eggs[new_egg.egg_id] = new_egg
	
	add_child(new_egg)
	
	var egg_info: Dictionary = new_egg.get_egg_info()
	
	egg_added.emit(egg_info, get_total_eggs())


func remove_egg(egg_id: String) -> int:
	eggs.erase(egg_id)
	
	return get_total_eggs()


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


func get_all_egg_info() -> Array[Dictionary]:
	var all_eggs_info: Array[Dictionary] = []
	
	for egg in eggs:
		all_eggs_info.append(eggs[egg].get_egg_info())
	
	return all_eggs_info


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


func get_total_eggs() -> int:
	return eggs.keys().size()


func _on_egg_hatched(egg_id: String) -> void:
	remove_egg(egg_id)
	
	egg_hatched.emit(egg_id, location_name)


func set_nest_capactiy(new_value: int) -> int:
	nest_capacity = new_value
	return nest_capacity


func nest_at_capacity() -> bool:
	if get_total_eggs() == nest_capacity:
		return true
	
	return false
