# This class is responsible for directing and coordinating the various managers and sending info
# back to the UI.
# Signals which do not require additional processing (e.g. bird hunger drops) bypass Managers and
# are reported directly to the Director

# Game Director
extends Node

signal update_hunger(hunger: int)
signal update_social(social: int)
signal update_energy(energy: int)
signal update_mood(mood: String)
signal update_status(status: String)
signal update_inventory(inventory: Inventory)
signal location_changed(location: Location)
signal egg_info_changed(egg_info: Dictionary, total_eggs: int)
signal egg_added(egg_info: Dictionary, total_eggs: int)
signal egg_removed(egg_info: Dictionary, total_eggs: int)
signal egg_progressed(egg_info: Dictionary)

var bird_manager: BirdManager
var inventory_manager: InventoryManager
var location_manager: LocationManager
var nest_manager: NestManager
var day_cycle_manager = DayCycleManager

var current_location_name: String

func _init() -> void:
	current_location_name = Locations.NAME_MEADOW


################################################################################
############################ Bird Manager Functions ############################
################################################################################


# Called by UI._director_setup
func set_bird_manager(manager: BirdManager) -> void:
	bird_manager = manager
	connect_to_bird()


func on_start_day() -> void:
	bird_manager.start_bird_day()


func get_bird_data() -> Dictionary:
	return bird_manager.get_bird_data()


func give_bird_food() -> void:
	bird_manager.give_food()


func end_bird_day() -> void:
	bird_manager.end_day()


################################################################################
############################ Bird Signal Functions #############################
################################################################################

func connect_to_bird() -> void:
	bird_manager.bird.hunger_changed.connect(_on_hunger_changed)
	bird_manager.bird.social_changed.connect(_on_social_changed)
	bird_manager.bird.energy_changed.connect(_on_energy_changed)
	bird_manager.bird.mood_changed.connect(_on_mood_changed)
	bird_manager.bird.status_changed.connect(_on_status_changed)
	#bird_manager.bird.inventory.change_to_ui.connect(_on_inventory_update)


func _on_hunger_changed(hunger: int) -> void:
	update_hunger.emit(hunger)


func _on_social_changed(social: int) -> void:
	update_social.emit(social)


func _on_energy_changed(energy: int) -> void:
	update_energy.emit(energy)


func _on_mood_changed(mood: String) -> void:
	update_mood.emit(mood)


func _on_status_changed(status: String) -> void:
	update_status.emit(status)

# TODO move to InventoryManager
func _on_inventory_update() -> void:
	pass


################################################################################
############################ Event Manager Functions ###########################
################################################################################


################################################################################
############################ Nest Manager Functions ############################
################################################################################

# Called by UI._director_setup
func set_nest_manager(manager: NestManager) -> void:
	nest_manager = manager


func has_nest() -> bool:
	return nest_manager.location_has_nest(current_location_name)


func add_nest() -> void:
	nest_manager.add_nest(current_location_name)


func get_nest() -> Nest:
	return nest_manager.get_nest(current_location_name)


func get_nest_info() -> Dictionary:
	return nest_manager.get_nest_info(current_location_name)


func get_nest_by_location(location_name: String) -> Dictionary:
	return nest_manager.get_nest_info(location_name)


# TODO Use actual BirdType when implemented
# Get egg type by using bird name
func lay_eggs() -> Array:
	var egg_type = bird_manager.bird.bird_name
	var response_code: int
	var response_message: String
	var total_eggs = nest_manager.add_egg(current_location_name, egg_type)
	
	# Check for alt cases (no nest, nest at capacity, TODO nest too damaged)
	if total_eggs == -1:
		response_code = total_eggs
		response_message= "%s does not have a nest built yet" % current_location_name
		
		return [response_code, response_message]
	
	elif total_eggs == -2:
		response_code = total_eggs
		response_message = "%s nest is at capacity! Upgrade nest capacity or wait for eggs to hatch before laying more" % current_location_name
		
		return [response_code, response_message]
	
	response_code = total_eggs
	response_message = str(total_eggs)
	
	return [response_code, response_message]


func remove_eggs(egg_id: int) -> String:
	var total_eggs = nest_manager.remove_egg(current_location_name, egg_id)
	if total_eggs == -1:
		return "%s does not have a nest built yet" % current_location_name
	
	return str(total_eggs)


func damage_nest(amount: int) -> String:
	var total_hp = nest_manager.damage_nest(current_location_name, amount)
	if total_hp == -1:
		return "%s does not have a nest built yet" % current_location_name
	
	return str(total_hp)


func repair_nest(amount: int) -> String:
	var total_hp = nest_manager.repair_nest(current_location_name, amount)
	if total_hp == -1:
		return "%s does not have a nest built yet" % current_location_name
	
	return str(total_hp)


func _on_egg_info_updated(egg_info: Dictionary) -> void:
	var nest_total_eggs = nest_manager.get_total_eggs(current_location_name)
	egg_info_changed.emit(egg_info, nest_total_eggs)


func _on_egg_progress(egg_info: Dictionary) -> void:
	egg_progressed.emit(egg_info)


func on_egg_added(egg_info: Dictionary, total_eggs: int) -> void:
	egg_added.emit(egg_info, total_eggs)


func on_egg_removed(egg_info: Dictionary, total_eggs: int) -> void:
	egg_removed.emit(egg_info, total_eggs)


func on_egg_hatched(egg_id: String, location_name: String) -> void:
	pass


################################################################################
########################## Location Manager Functions ##########################
################################################################################

func set_location_manager(manager: LocationManager) -> void:
	location_manager = manager
	location_manager.location_changed.connect(_on_new_location)


func get_all_locations() -> Array[Location]:
	return location_manager.all_locations


func get_nest_material_needed() -> int:
	return location_manager.current_location.nest_material_needed


func get_current_location_name() -> String:
	return location_manager.current_location.location_name


func get_current_location() -> Location:
	return location_manager.current_location


func change_location(location_name: String) -> void:
	location_manager.change_location(location_name)


func _on_new_location(location: Location) -> void:
	current_location_name = location.location_name
	location_changed.emit()


################################################################################
########################## Inventory Manager Functions #########################
################################################################################

func set_inventory_manager(manager: InventoryManager) -> void:
	inventory_manager = manager


func get_bird_inventory() -> Inventory:
	return inventory_manager.get_inventory()


func on_add_item(item_name: String) -> void:
	inventory_manager.add_item(item_name)


func get_all_nesting_items() -> Array[Item]:
	return inventory_manager.get_nesting_items()


func can_build_nest() -> bool:
	var material_needed = location_manager.get_nesting_material_needed()
	return inventory_manager.can_build_nest(material_needed)


func on_items_used(items_used: Array) -> void:
	inventory_manager.use_items(items_used)


################################################################################
########################### Danger Manager Functions ###########################
################################################################################


################################################################################
######################### Day Cycle Manager Functions ##########################
################################################################################

func set_day_cycle_manager(manager: DayCycleManager) -> void:
	day_cycle_manager = manager
