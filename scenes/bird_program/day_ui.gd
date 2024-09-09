# Assigns Managers to Director and updates UI according to signals from Director
# and responds to Player inputs

extends CanvasLayer


var meadow_observations: Array[Observation] = []
var woods_observations: Array[Observation] = []
var marsh_observations: Array[Observation] = []

var bird_data: Dictionary = {}

# Textures
@onready var image_player: TextureRect = %PlayerImage
@onready var bg_texture_rect: TextureRect = %BGTextureRect

# Player Labels
@onready var label_date_header: Label = %DateHeaderLabel
@onready var label_bird_name: Label = %BirdName
@onready var label_bird_level: Label = %BirdLevel
@onready var label_bird_food_type: Label = %FoodType
@onready var label_bird_behavior: Label = %Behavior
@onready var label_bird_status: Label = %BirdStatus
@onready var label_bird_mood: Label = %BirdMood
@onready var label_bird_nest_status: Label = %NestStatus

# Player Inventory Labels
@onready var label_inv_nesting: Label = %NestMatLabel
@onready var label_inv_valuables: Label = %ValuablesLabel
@onready var label_inv_misc: Label = %MiscItemsLabel

# Meters
@onready var clock: TextureRect = %ClockfaceTextureRect
@onready var label_time_of_day: Label = %TimeOfDayLabel


# Bird Meter Progress Bars
@onready var progress_bar_hunger: ProgressBar = %HungerProgressBar
@onready var progress_bar_social: ProgressBar = %SocialProgressBar
@onready var progress_bar_energy: ProgressBar = %EnergyProgressBar

# Current Location Labels
@onready var label_location_name: Label = %BirdLocation
@onready var label_location_food: Label = %LocationFood
@onready var label_location_threat_level: Label = %LocationThreatLevel
@onready var label_location_threat: Label = %LocationThreat

# Message Labels
@onready var label_message_type: Label = %MessageTypeLabel
@onready var label_message: Label = %MessageLabel

# Buttons
@onready var button_interact_bird: OptionButton = %ActionButton
@onready var button_change_location: OptionButton = %LocationButton
@onready var button_view_nest: Button = %ViewNestButton
@onready var button_hide: Button = %HideButton

# Popup Menus
@onready var inventory_ui: InventoryUI = %InventoryUI
@onready var select_nesting_ui: SelectNestingUI = %SelectNestingUI
@onready var window_nest_view: Window = %NestViewWindow

# End of Day Popups
@onready var popup_end_day_confirm: ConfirmationDialog = %EndDayConfirmation
@onready var popup_end_day_summary: AcceptDialog = %EndDaySummary

# Game Managers
@onready var bird_manager: BirdManager = %BirdManager
@onready var nest_manager: NestManager = %NestManager
@onready var location_manager: LocationManager = %LocationManager
@onready var inventory_manager: InventoryManager = %InventoryManager
@onready var day_cycle_manager: DayCycleManager = %DayCycleManager
@onready var xp_manager: XpManager = %XpManager


# Debug tools
@onready var debug_option_button: OptionButton = %DebugOptionButton
@onready var item_debug_popup = %ItemDebugPopup


# Connect managers to Director
# Populate locations in location button
# Load the Player's bird
func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	_director_setup()
	_load_location()
	_populate_location_button()
	_get_all_observations()
	_connect_ui_elements()
	_load_player_bird()
	
	
	Director.start_new_day()


################################################################################
############################### Setup Functions ################################
################################################################################

# Called from _ready. Sets the correct managers for the GameDirector
# Connects Director's signals from updates
func _director_setup() -> void:
	Director.set_bird_manager(bird_manager)
	Director.set_location_manager(location_manager)
	Director.set_nest_manager(nest_manager)
	Director.set_inventory_manager(inventory_manager)
	Director.set_day_cycle_manager(day_cycle_manager)
	Director.set_xp_manager(xp_manager)
	
	# General signals
	Director.location_changed.connect(_on_location_changed)
	# Bird signals
	Director.update_hunger.connect(_on_hunger_changed)
	Director.update_social.connect(_on_social_changed)
	Director.update_energy.connect(_on_energy_changed)
	Director.update_mood.connect(_on_mood_changed)
	Director.update_status.connect(_on_status_changed)
	# Egg signals
	Director.egg_info_changed.connect(_on_egg_info_updated)
	Director.egg_added.connect(_on_egg_added)
	Director.egg_progressed.connect(_on_egg_progress)
	# Nest signals
	Director.nest_info_changed.connect(_on_nest_updated)
	Director.current_nest_info_changed.connect(_on_current_nest_updated)
	
	select_nesting_ui.items_used.connect(Director.on_items_used)

################################### UI Setup ###################################

# Loads info from each Location into their appropriate UI elements
func _load_location() -> void:
	var current_location: Location = Director.get_current_location()
	
	bg_texture_rect.texture = current_location.background
	label_location_name.text = current_location.location_name
	label_location_threat_level.text = current_location.threat_level
	
	# Put FoodType names into an Array, then join them separated by a comma
	var food_types: Array[FoodType] = current_location.food_types
	var food_names: Array[String] = []
	for food_type in food_types:
		food_names.append(food_type.name)
	
	var food_names_string: String = String(", ").join(food_names)
	
	label_location_food.text = food_names_string
	
	var threats: String = String(", ").join(current_location.threats)
	
	label_location_threat.text = threats
	
	if Director.has_nest():
		label_bird_nest_status.text = GlobalMessages.LABEL_TEXT_HAS_NEST
	else:
		label_bird_nest_status.text = GlobalMessages.LABEL_TEXT_NO_NEST


# Gets all locations and adds option in change location button for each
func _populate_location_button() -> void:
	#for location in Manager.location_manager.all_locations:
	for location in Director.get_all_locations():
		var i: int = 1
		button_change_location.add_item(location.location_name, i)
		i += 1


# Loads and randomizes all observations for each location
func _get_all_observations() -> void:
	#var all_locations: Array[Location] = Manager.location_manager.all_locations.duplicate(true)
	var all_locations: Array[Location] = Director.get_all_locations().duplicate(true)
	
	for location in all_locations:
		match location.location_name:
			"Meadow":
				meadow_observations = location.observations.duplicate(true)
				meadow_observations.shuffle()
			"Woods":
				woods_observations = location.observations.duplicate(true)
				woods_observations.shuffle()
			"Marsh":
				marsh_observations = location.observations.duplicate(true)
				marsh_observations.shuffle()
			_:
				print("Error! Unknown location")


# Connects buttons and popups to given functions
func _connect_ui_elements() -> void:
	day_cycle_manager.increment_time.connect(_on_cycle_increment)
	
	button_interact_bird.connect("item_selected", _on_interact_pressed)
	button_change_location.connect("item_selected", _on_change_location_pressed)
	popup_end_day_confirm.connect("confirmed", _on_end_day_confirmed)
	popup_end_day_summary.connect("confirmed", _start_next_day)
	select_nesting_ui.connect("nest_built", _on_nest_built)
	
	window_nest_view.lay_eggs_pressed.connect(_on_lay_eggs_pressed)


# Updates UI with latest data from Bird
func _load_player_bird() -> void:
	_get_updated_bird_data()
	
	label_date_header.text = "Day " + str(bird_data[BirdGlobals.BIRD_AGE_KEY])
	image_player.texture = bird_data[BirdGlobals.BIRD_IMAGE_KEY]
	label_bird_name.text = bird_data[BirdGlobals.BIRD_NAME_KEY]
	label_bird_level.text = str(bird_data[BirdGlobals.BIRD_LEVEL_KEY])
	label_bird_food_type.text = bird_data[BirdGlobals.BIRD_FOOD_TYPE_KEY]
	label_bird_status.text = bird_data[BirdGlobals.BIRD_STATUS_KEY]
	label_bird_mood.text = bird_data[BirdGlobals.BIRD_MOOD_KEY]
	
	# TODO Nest not yet implemented
	label_bird_nest_status.text = "No Nest"


# Gets latest bird data
func _get_updated_bird_data() -> void:
	bird_data = Director.get_bird_data()


func _start_next_day() -> void:
	Director.start_new_day()
	_load_player_bird()


################################################################################
######################### Message and Alert Functions ##########################
################################################################################

func _display_observation_message(observation: Observation) -> void:
	label_message_type.text = observation.observation_type.type_name + ":"
	label_message.text = observation.observation_mesage


func _display_action_message(alert_type: String, alert_message: String) -> void:
	label_message_type.text = alert_type
	label_message.text = alert_message


################################################################################
############################### Bird Functions #################################
################################################################################

func _on_hunger_changed(hunger: int) -> void:
	progress_bar_hunger.value = hunger


func _on_social_changed(social: int) -> void:
	progress_bar_social.value = social


func _on_energy_changed(energy: int) -> void:
	progress_bar_energy.value = energy


func _on_mood_changed(mood: String) -> void:
	label_bird_mood.text = mood


func _on_status_changed(status: String) -> void:
	label_bird_status.text = status


################################################################################
############################# Day Cycle Functions ##############################
################################################################################

func _on_cycle_increment(cycles: int, time_of_day: int) -> void:
	clock.on_time_incremented(cycles)
	
	match time_of_day:
		GameGlobals.DayNightCycle.MORNING:
			label_time_of_day.text = GameGlobals.TIME_TEXT_MORNING
		GameGlobals.DayNightCycle.DAY:
			label_time_of_day.text = GameGlobals.TIME_TEXT_DAY
		GameGlobals.DayNightCycle.EVENING:
			label_time_of_day.text = GameGlobals.TIME_TEXT_EVENING
		GameGlobals.DayNightCycle.NIGHT:
			label_time_of_day.text = GameGlobals.TIME_TEXT_NIGHT
		_:
			label_time_of_day.text = "Unknown"


################################################################################
############################## Nest Functions ##################################
################################################################################

# Runs after nest_built signal from SelectNestingUI
func _on_nest_built():
	Director.add_nest()
	label_bird_nest_status.text = "Nest Built"
	_display_action_message(GlobalMessages.ALERT_ACTION, GlobalMessages.MESSAGE_BUILT_NEST)


# If nest updated is NOT the current nest being displayed, display appropriate message based on status code
func _on_nest_updated(nest_info: Dictionary, status_code: int) -> void:
	if (status_code == GameGlobals.StatusCode.EGG_HATCHED):
		var message: String = GlobalMessages.EGG_HATCHED % [nest_info[NestGlobals.NEST_LOCATION_NAME]]
		_display_action_message(GlobalMessages.ALERT_MESSAGE, message)
	elif (status_code == GameGlobals.StatusCode.EGG_BROKEN):
		var message: String = GlobalMessages.EGG_BROKEN % [nest_info[NestGlobals.NEST_LOCATION_NAME]]
		_display_action_message(GlobalMessages.ALERT_MESSAGE, message)


# If Nest is current one in view display updated message based on status code and update nest
func _on_current_nest_updated(nest_info: Dictionary, status_code: int) -> void:
	if (status_code == GameGlobals.StatusCode.EGG_HATCHED):
		var message: String = GlobalMessages.EGG_HATCHED % [nest_info[NestGlobals.NEST_LOCATION_NAME]]
		_display_action_message(GlobalMessages.ALERT_MESSAGE, message)
	elif (status_code == GameGlobals.StatusCode.EGG_BROKEN):
		var message: String = GlobalMessages.EGG_BROKEN % [nest_info[NestGlobals.NEST_LOCATION_NAME]]
		_display_action_message(GlobalMessages.ALERT_MESSAGE, message)
	
	window_nest_view.load_nest(nest_info)


func _on_egg_info_updated(egg_info: Dictionary, total_eggs: int) -> void:
	window_nest_view.on_updated_egg(egg_info, total_eggs)


func _on_egg_progress(egg_progress: Dictionary) -> void:
	window_nest_view.on_egg_progress(egg_progress)


func _on_egg_added(egg_info: Dictionary, total_eggs: int) -> void:
	window_nest_view.place_new_egg(egg_info, total_eggs)

################################################################################
############################ Location Functions ################################
################################################################################

func _on_location_changed():
	_load_location()


func _on_end_day_confirmed() -> void:
	popup_end_day_confirm.visible = false
	#await MainBird.end_day()
	Director.on_end_of_day()
	_get_updated_bird_data()
	_end_of_day_summary()


################################################################################
############################ Inventory Functions ###############################
################################################################################

func _on_inventory_update(item_type: String, amount: int) -> void:
	match item_type:
		
		ItemGlobals.ITEM_TYPE_NESTING:
			label_inv_nesting.text = str(amount)
		
		ItemGlobals.ITEM_TYPE_VALUABLE:
			label_inv_valuables.text = str(amount)
		
		ItemGlobals.ITEM_TYPE_MISCELLANEOUS:
			label_inv_misc.text = str(amount)

################################################################################
################################ Input Signals #################################
################################################################################

# Opens/ closes inventory
func _toggle_inventory():
	if inventory_ui.visible:
		inventory_ui.visible = false
	else:
		inventory_ui.open(Director.get_bird_inventory())


# Updates action message
func _on_look_for_food_pressed() -> void:
	label_message_type.text = "Action: "
	label_message.text = "Got some food!"
	#MainBird.get_food()
	Director.give_bird_food()


# Gets interaction from interaction button
func _on_interact_pressed(item: int) -> void:
	button_interact_bird.selected = 0
	
	match item:
		1:
			get_location_observation()
		2:
			_on_look_for_food_pressed()
		3:
			_on_build_nest_pressed()
		4:
			_on_lay_eggs_pressed()
		5:
			_on_repair_nest_pressed()
		6:
			print("Sleep pressed")
			_on_sleep_pressed()
		_:
			pass


func _on_change_location_pressed(location_index: int) -> void:
	var location_name: String = button_change_location.get_item_text(location_index)
	
	Director.change_location(location_name)


func _on_build_nest_pressed() -> void:
	if Director.has_nest():
		_display_action_message(GlobalMessages.ALERT_ACTION, GlobalMessages.MESSAGE_NEST_ALREADY_BUILT)
		return
	
	if Director.can_build_nest():
		_toggle_nest_building_ui()
	else:
		_display_action_message(GlobalMessages.ALERT_ACTION, GlobalMessages.MESSAGE_NOT_ENOUGH_MATERIAL)


# Called after build nest is pressed if Player has enough nesting material
# Gets Player inventory and how much material is needed
func _toggle_nest_building_ui() -> void:
	if select_nesting_ui.visible:
		select_nesting_ui.visible = false
	else:
		select_nesting_ui.open(Director.get_all_nesting_items(), Director.get_nest_material_needed())


# Gets a response code from Director and displays appropriate message
# If invalid request, gets -1 if no nest is built, -2 if nest is full
# If valid request, displays total eggs
func _on_lay_eggs_pressed() -> void:
	var response: Array = Director.lay_eggs()
	
	if response[0] == -1:
		_display_action_message(GlobalMessages.ALERT_ACTION, response[1])
		return
	
	elif response[0] == -2:
		_display_action_message(GlobalMessages.ALERT_ACTION, response[1])
		return
	
	_display_action_message(GlobalMessages.ALERT_ACTION, "You laid an egg! You now have %s eggs." % response[1])


func _on_repair_nest_pressed():
	if Director.has_nest():
		# TODO prompt player that current location does not have a nest or disable that option from appearing
		pass
	
	#MainBird.repair_nest(1)
	Director.on_repair_nest(1)


func _on_view_nest_pressed() -> void:
	if !Director.has_nest():
		_display_action_message(GlobalMessages.ALERT_ACTION, GlobalMessages.MESSAGE_NO_NEST)
		return
	
	var nest_info: Dictionary = Director.get_nest_info()
	
	window_nest_view.load_nest(nest_info)
	window_nest_view.show()


func _on_sleep_pressed() -> void:
	popup_end_day_confirm.visible = true


# Gets key press inputs and runs given function
func _unhandled_input(event):
	if event.is_action_released("Inventory"):
		_toggle_inventory()
		
	elif event.is_action_pressed("DebugMenu"):
		_toggle_debug_menu()


################################################################################
######################## Observations and Discoveries ##########################
################################################################################

# Gets next obesrvation from array
func get_location_observation():
	match Director.get_current_location_name():
	#match Manager.location_manager.current_location.location_name:
		"Meadow":
			_display_observation_message(meadow_observations.pop_front())
		"Marsh":
			pass
		"Woods":
			pass


################################################################################
########################### Frontend Data Functions ############################
################################################################################

func _end_of_day_summary() -> void:
	popup_end_day_summary.visible = true
	# TODO Check if date is advanced too early
	popup_end_day_summary.title = "Day " + str(bird_data[BirdGlobals.BIRD_AGE_KEY]) + " Completed"
	popup_end_day_summary.dialog_text = _generate_end_of_day_text()


func _generate_end_of_day_text() -> String:
	return """Day {date} Summary:
	XP Earned: {xp_earned}
	Total Experience: {total_xp}
	Current Level: {level}
	XP needed for next level: 999""".format({
		"date": bird_data[BirdGlobals.BIRD_AGE_KEY],
		"xp_earned": bird_data[BirdGlobals.BIRD_DAILY_EXPERIENCE_KEY],
		"total_xp": bird_data[BirdGlobals.BIRD_TOTAL_EXPERIENCE_KEY],
		"level": bird_data[BirdGlobals.BIRD_LEVEL_KEY]
	})


################################################################################
############################### Debug Functions ################################
################################################################################

func _toggle_debug_menu() -> void:
	if debug_option_button.visible:
		debug_option_button.visible = false
	else:
		debug_option_button.visible = true


func _on_debug_item_selected(index: int) -> void:
	match(index):
		1:
			_add_item()
		2:
			pass
		3:
			pass
		4:
			pass
		_:
			pass


func _add_item() -> void:
	debug_option_button.selected = 0
	item_debug_popup.visible = true


func _clear_nesting() -> void:
	pass


func _clear_valuables() -> void:
	pass


func _clear_misc() -> void:
	pass
