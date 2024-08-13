class_name Egg
extends Node

signal egg_hatched(egg_id: String)
signal egg_info_changed(egg_info: Dictionary)
signal egg_progress(egg_info: Dictionary)

var egg_type: EggType
var egg_id: String
var egg_image: Texture2D
var egg_max_health: int
var egg_current_health: int
var egg_incubation_time_remaining: int
var egg_total_incubation_time: int
var is_incubating: bool

var incubation_timer: Timer


# Only EggType is needed when creating. Sets properties based on EggType
# Sets Timer and adds Timer as child
func _init(type: EggType, egg_location: String, egg_number: int) -> void:
	egg_type = type
	
	#egg_id = _get_egg_id(egg_location, egg_number)
	egg_id = "%s_%d" % [egg_location, egg_number]
	
	egg_image = egg_type.image
	egg_total_incubation_time = egg_type.incubation_time
	egg_incubation_time_remaining = egg_total_incubation_time
	egg_max_health = 100
	egg_current_health = egg_max_health
	# TODO Change to false. Set to true for debugging
	is_incubating = true


func _ready() -> void:
	incubation_timer = Timer.new()
	incubation_timer.wait_time = 1
	incubation_timer.timeout.connect(_on_incubation_timer_timeout)
	
	egg_info_changed.connect(Director._on_egg_info_updated)
	egg_progress.connect(Director._on_egg_progress)
	
	add_child(incubation_timer)
	
	# TODO Incubation started automatically for debugging
	start_incubating()
	


func update_ui() -> Dictionary:
	var egg_info: Dictionary = {}
	
	return egg_info


func start_incubating() -> void:
	is_incubating = true
	incubation_timer.start()


func stop_incubating() -> void:
	is_incubating = false
	incubation_timer.stop()


# On each timeout (1 second) subtract from total incubation time and emit progress
# signal with egg id and time remaining
func _on_incubation_timer_timeout() -> void:
	if is_incubating:
		egg_incubation_time_remaining -= 1
		
		if egg_incubation_time_remaining <= 0:
			hatch_egg()
			return
		
		else:
			incubation_timer.start()
	
	egg_progress.emit(get_simplified_info())


func hatch_egg() -> void:
	egg_hatched.emit(egg_id)
	stop_incubating()


################################################################################
############################## Utility Functions ###############################
################################################################################

# Gets all egg info to update UI
func get_egg_info() -> Dictionary:
	var egg_info: Dictionary = {}
	
	egg_info[EggGlobals.EGG_INFO_ID] = egg_id
	egg_info[EggGlobals.EGG_INFO_TYPE] = egg_type
	egg_info[EggGlobals.EGG_INFO_IMAGE] = egg_image
	egg_info[EggGlobals.EGG_INFO_MAX_HEALTH] = egg_max_health
	egg_info[EggGlobals.EGG_INFO_CURRENT_HEALTH] = egg_current_health
	egg_info[EggGlobals.EGG_INFO_TOTAL_INCUBATION_TIME] = egg_total_incubation_time
	egg_info[EggGlobals.EGG_INFO_INCUBATION_TIME_REMAINING] = egg_incubation_time_remaining
	egg_info[EggGlobals.EGG_INFO_IS_INCUBATING] = is_incubating
	
	return egg_info


# Gets egg_id and time_remaining to update ProgressBar in UI
func get_simplified_info() -> Dictionary:
	var egg_info: Dictionary = {}
	
	egg_info[EggGlobals.EGG_INFO_ID] = egg_id
	egg_info[EggGlobals.EGG_INFO_INCUBATION_TIME_REMAINING] = egg_incubation_time_remaining
	
	return egg_info


#func _get_egg_id(location_name: String, egg_number: int) -> String:
	#var egg_id: String = location_name + str(egg_number)
	#
	#return egg_id
