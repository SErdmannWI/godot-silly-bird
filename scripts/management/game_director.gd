# This class is responsible for directing and coordinating the various managers and sending info
# back to the UI.
# Signals which only affect UI components bypass Managers and are reported to the Director
# Signals which require additional logic further down are first reported to their respective Manager
# and then reported to the Director via the Manager.

# Game Director
extends Node

signal update_hunger(hunger: int)
signal update_social(social: int)
signal update_energy(energy: int)
signal update_mood(mood: String)
signal update_status(status: String)
signal update_inventory(inventory: Inventory)
signal location_changed(location: Location)
signal nest_info_changed(nest_info: Dictionary, status_code: int)
signal current_nest_info_changed(nest_info: Dictionary)
signal egg_info_changed(egg_info: Dictionary, total_eggs: int)
signal egg_added(egg_info: Dictionary, total_eggs: int)
signal egg_progressed(egg_info: Dictionary)
signal temperature_changed(current_temp: int)

var bird_manager: BirdManager
var inventory_manager: InventoryManager
var location_manager: LocationManager
var nest_manager: NestManager
var day_cycle_manager: DayCycleManager
var xp_manager: XpManager

var current_location_name: String

func _init() -> void:
	current_location_name = Locations.NAME_MEADOW


################################################################################
############################### Global Functions ###############################
################################################################################

func start_new_day() -> void:
	get_tree().call_group(GameGlobals.GROUP_NAME_MANAGERS, GameGlobals.GROUP_METHOD_START_DAY)


# Get Daily XP, add to Bird
func on_end_of_day() -> void:
	get_tree().call_group(GameGlobals.GROUP_NAME_MANAGERS, GameGlobals.GROUP_METHOD_END_DAY)
	
	var daily_xp_gained: int = xp_manager.get_xp_running_total()
	bird_manager.add_xp_to_bird(daily_xp_gained)


################################################################################
############################ Bird Manager Functions ############################
################################################################################

# Called by UI._director_setup
func set_bird_manager(manager: BirdManager) -> void:
	bird_manager = manager
	connect_to_bird()


func get_bird_data() -> Dictionary:
	return bird_manager.get_bird_data()


func give_bird_food() -> void:
	bird_manager.give_food()


func end_bird_day() -> void:
	bird_manager.end_day()


############# Bird Signal Functions #############

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

############# Nest Action Functions #############

# Calls NestManager.add_egg. Checks if valid request. If not, send message to UI to be displayed.
# If valid request, connect UI signals and send message to UI to be displayed.
func lay_eggs() -> Array:
	var egg_type = bird_manager.bird.bird_name
	var response_code: int
	var response_message: String
	
	# Array will contain [response_code, Egg] if valid request
	var response: Array = nest_manager.add_egg(current_location_name, egg_type)
	response_code = response[0]
	
	# Check for alt cases (no nest, nest at capacity, TODO nest too damaged)
	if response_code == GameGlobals.ResponseCode.NO_NEST:
		response_message= "%s does not have a nest built yet" % current_location_name
		
		return [response_code, response_message]
	
	elif response_code == GameGlobals.ResponseCode.NEST_FULL:
		response_message = "%s nest is at capacity! Upgrade nest capacity or wait for eggs to hatch before laying more" % current_location_name
		
		return [response_code, response_message]
	
	# Connect new egg UI signals to Director
	response[1].info_changed.connect(_on_egg_info_updated)
	response[1].progress.connect(_on_egg_progress)
	
	response_message = str(response_code)
	
	return [response_code, response_message]


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


############# Nest Info Functions #############

# Called by UI._director_setup
func set_nest_manager(manager: NestManager) -> void:
	nest_manager = manager
	manager.egg_hatched.connect(_on_egg_hatched)
	manager.egg_broken.connect(_on_egg_broken)

func has_nest() -> bool:
	return nest_manager.location_has_nest(current_location_name)


func add_nest() -> void:
	var new_nest: Nest = nest_manager.add_nest(current_location_name)
	new_nest.egg_added.connect(_on_egg_added)


func get_nest() -> Nest:
	return nest_manager.get_nest(current_location_name)


func get_nest_info() -> Dictionary:
	return nest_manager.get_nest_info(current_location_name)


func get_nest_by_location(location_name: String) -> Dictionary:
	return nest_manager.get_nest_info(location_name)


############# Nest Signal Functions #############

# From Egg when health or image change
func _on_egg_info_updated(egg_info: Dictionary) -> void:
	var nest_total_eggs = nest_manager.get_total_eggs(current_location_name)
	egg_info_changed.emit(egg_info, nest_total_eggs) # -> UI

# From Egg when incubation progress changes
func _on_egg_progress(egg_info: Dictionary) -> void:
	egg_progressed.emit(egg_info) # -> UI


func _on_egg_added(egg_info: Dictionary, total_eggs: int) -> void:
	egg_added.emit(egg_info, total_eggs) # -> UI


# Add XP to Player's bird
# If nest is current nest, signal to UI to update current view. Otherwise, simply signal the change
func _on_egg_hatched(nest_info: Dictionary) -> void:
	if current_location_name == nest_info[NestGlobals.NEST_LOCATION_NAME]:
		current_nest_info_changed.emit(nest_info, GameGlobals.StatusCode.EGG_HATCHED) # -> UI
	else:
		nest_info_changed.emit(nest_info, GameGlobals.StatusCode.EGG_HATCHED) # -> UI
	
	_xp_added(GameGlobals.XpCodes.EGG_HATCHED)


# Signal to UI to update nest
func _on_egg_broken(nest_info: Dictionary) -> void:
	if current_location_name == nest_info[NestGlobals.NEST_LOCATION_NAME]:
		current_nest_info_changed.emit(nest_info, GameGlobals.StatusCode.EGG_BROKEN)
	else:
		nest_info_changed.emit(nest_info, GameGlobals.StatusCode.EGG_BROKEN)


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
############################# XP Manager Functions #############################
################################################################################

func set_xp_manager(manager: XpManager) -> void:
	xp_manager = manager

func _check_level() -> void:
	pass

# Called whenever a Player has earned xp from an action or event
func _xp_added(xp_code: int) -> void:
	xp_manager.increment_xp(GameGlobals.XP_AMOUNT_GAINED[xp_code])


################################################################################
######################### Day Cycle Manager Functions ##########################
################################################################################

func set_day_cycle_manager(manager: DayCycleManager) -> void:
	day_cycle_manager = manager
	day_cycle_manager.temperature_changed.connect(_temperature_changed)


func get_current_temperature() -> int:
	var current_temp = day_cycle_manager.get_current_temp()
	
	return current_temp


func _temperature_changed(current_temp: int) -> void:
	temperature_changed.emit(current_temp)

