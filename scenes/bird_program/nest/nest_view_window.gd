extends Window

signal lay_eggs_pressed

const EGG_POSITION_OFFSET_X: int = -16
const EGG_POSITION_OFFSET_Y: int = -16

var egg_texture: Texture2D

var egg_markers: Array = []
var all_markers: Array = []

var one_egg_marker: Marker2D
var two_egg_markers: Array[Marker2D] = []
var three_egg_markers: Array[Marker2D] = []
var four_egg_markers: Array[Marker2D] = []
var five_egg_markers: Array[Marker2D] = []
var six_egg_markers: Array[Marker2D] = []

@onready var egg_scene: PackedScene = preload(FilePaths.SCENE_NEST_EGG)
@onready var egg_progress_scene: PackedScene = preload(FilePaths.SCENE_NEST_EGG_PROGRESS)

# Egg Markers
@onready var egg_marker_11: Marker2D = %EggMarker11
@onready var egg_marker_21: Marker2D = %EggMarker21
@onready var egg_marker_22: Marker2D = %EggMarker22
@onready var egg_marker_41: Marker2D = %EggMarker41
@onready var egg_marker_42: Marker2D = %EggMarker42
@onready var egg_marker_43: Marker2D = %EggMarker43
@onready var egg_marker_44: Marker2D = %EggMarker44
@onready var egg_marker_52: Marker2D = %EggMarker52
@onready var egg_marker_53: Marker2D = %EggMarker53
@onready var egg_marker_54: Marker2D = %EggMarker54
@onready var egg_marker_55: Marker2D = %EggMarker55
@onready var egg_marker_61: Marker2D = %EggMarker61
@onready var egg_marker_62: Marker2D = %EggMarker62
@onready var egg_marker_63: Marker2D = %EggMarker63
@onready var egg_marker_64: Marker2D = %EggMarker64
@onready var egg_marker_65: Marker2D = %EggMarker65
@onready var egg_marker_66: Marker2D = %EggMarker66

# UI Displays
@onready var vbox_egg_progress: VBoxContainer = %EggProgressVBox

@onready var texture_rect_nest: TextureRect = %NestImageTextRect

@onready var progress_bar_nest_health: ProgressBar = %NestHealthProgressBar

@onready var label_nest_location: Label = %NestLocation
@onready var label_nest_type: Label = %NestType
@onready var label_nest_status: Label = %NestStatus
@onready var label_nest_level: Label = %NestLevel
@onready var label_nest_capacity: Label = %NestCapacity

# Buttons
@onready var button_lay_eggs: Button = %LayEggsButton


# Called when the node enters the scene tree for the first time.
func _ready():
	_set_available_egg_positions()
	_set_egg_texture()
	
	_connect_buttons()


################################################################################
############################### Setup Functions ################################
################################################################################

# Load arrays of Marker2Ds for each possible set of eggs up to 6
func _set_available_egg_positions() -> void:
	one_egg_marker = egg_marker_11
	two_egg_markers = [egg_marker_21, egg_marker_22]
	three_egg_markers = [egg_marker_21, egg_marker_11, egg_marker_22]
	four_egg_markers = [egg_marker_41, egg_marker_42, egg_marker_43, egg_marker_44]
	five_egg_markers = [egg_marker_11, egg_marker_52, egg_marker_53, egg_marker_54, egg_marker_55]
	six_egg_markers = [egg_marker_61, egg_marker_62, egg_marker_63, egg_marker_64, egg_marker_65, egg_marker_66]
	
	all_markers = [egg_marker_11, egg_marker_21, egg_marker_22, egg_marker_41, egg_marker_42, egg_marker_43,
	egg_marker_44, egg_marker_52, egg_marker_53, egg_marker_54, egg_marker_55, egg_marker_61, egg_marker_62,
	egg_marker_63, egg_marker_64, egg_marker_65, egg_marker_66]
	
	egg_markers = [one_egg_marker, two_egg_markers, three_egg_markers, four_egg_markers, five_egg_markers, six_egg_markers]


func _connect_buttons() -> void:
	button_lay_eggs.pressed.connect(_on_lay_eggs_pressed)

# TODO Fix this to have textures other than the default value
func _set_egg_texture(_texture_path: String = FilePaths.IMAGE_EGG_DEFAULT) -> void:
	egg_texture = preload(FilePaths.IMAGE_EGG_DEFAULT)


################################################################################
########################## Update Display Functions ############################
################################################################################

func load_nest(nest_info: Dictionary) -> void:
	label_nest_location.text = nest_info[NestGlobals.NEST_LOCATION_NAME]
	label_nest_status.text = nest_info[NestGlobals.NEST_STATUS]
	label_nest_type.text = nest_info[NestGlobals.NEST_TYPE]
	label_nest_level.text = str(nest_info[NestGlobals.NEST_LEVEL])
	label_nest_capacity.text = str(nest_info[NestGlobals.NEST_CAPACTIY])
	
	progress_bar_nest_health.max_value = nest_info[NestGlobals.NEST_MAX_HP]
	progress_bar_nest_health.value = nest_info[NestGlobals.NEST_HP]
	
	# If nest has eggs, place eggs. Else, clear display of any eggs left from previous loaded nest
	if nest_info[NestGlobals.NEST_EGGS].size() > 0:
		print(str(nest_info[NestGlobals.NEST_EGGS].size()))
		_place_all_eggs(nest_info[NestGlobals.NEST_EGGS])
	else:
		for marker in all_markers:
			for child in marker.get_children():
				child.queue_free()
		
		for child in vbox_egg_progress.get_children():
			child.queue_free()


func _place_all_eggs(eggs: Array[Dictionary]) -> void:
	if eggs.size() == 1:
		var egg_info: Dictionary = eggs[0]
		_instantiate_single_egg_scene(egg_info)
		return
	else:
		_instatiate_multiple_egg_scenes(eggs)
	


func _instantiate_single_egg_scene(egg_info: Dictionary) -> void:
	var new_egg_scene = egg_scene.instantiate()
	new_egg_scene.set_egg_id(egg_info[EggGlobals.EGG_INFO_ID])
	new_egg_scene.set_tooltip()
	
	var marker = _get_markers(1)
	
	if marker.get_child_count() > 0:
		marker.remove_child(marker.get_child(0))
	
	marker.add_child(new_egg_scene)
	
	# Create new Progress bar scene, set properties and add to VBox
	var new_egg_progress_bar = egg_progress_scene.instantiate()
	new_egg_progress_bar.set_egg_id(egg_info[EggGlobals.EGG_INFO_ID])
	new_egg_progress_bar.set_progress_bar_values(egg_info[EggGlobals.EGG_INFO_TOTAL_INCUBATION_TIME],
	egg_info[EggGlobals.EGG_INFO_INCUBATION_TIME_REMAINING])
	
	if vbox_egg_progress.get_child_count() > 0:
		for child in vbox_egg_progress.get_children():
			child.queue_free()
	
	vbox_egg_progress.add_child(new_egg_progress_bar)


func _instatiate_multiple_egg_scenes(eggs: Array[Dictionary]) -> void:
	# Clear Progress Bar VBox of previous
	for child in vbox_egg_progress.get_children():
		child.queue_free()
	
	var markers: Array[Marker2D] = _get_markers(eggs.size())
	
	# Remove children from markers and place in new egg scenes
	var egg_index: int = 0
	for marker in markers:
		for child in marker.get_children():
			child.queue_free()
		
		var new_egg_scene = egg_scene.instantiate()
		new_egg_scene.set_egg_id(eggs[egg_index][EggGlobals.EGG_INFO_ID])
		new_egg_scene.set_tooltip()
		
		marker.add_child(new_egg_scene)
		
		var new_egg_progress_bar = egg_progress_scene.instantiate()
		new_egg_progress_bar.set_egg_id(eggs[egg_index][EggGlobals.EGG_INFO_ID])
		new_egg_progress_bar.set_progress_bar_values(eggs[egg_index][EggGlobals.EGG_INFO_TOTAL_INCUBATION_TIME],
		eggs[egg_index][EggGlobals.EGG_INFO_INCUBATION_TIME_REMAINING])
		
		vbox_egg_progress.add_child(new_egg_progress_bar)
		
		egg_index += 1


func place_new_egg(egg_info: Dictionary, total_eggs: int) -> void:
	# If only one egg, create scene and add egg to only used marker
	if total_eggs == 1:
		var new_egg_scene = egg_scene.instantiate()
		new_egg_scene.set_egg_id(egg_info[EggGlobals.EGG_INFO_ID])
		new_egg_scene.set_tooltip()
		var marker = _get_markers(total_eggs)
		
		marker.add_child(new_egg_scene)
		
		# Create new Progress bar scene, set properties and add to VBox
		var new_egg_progress_bar = egg_progress_scene.instantiate()
		new_egg_progress_bar.set_egg_id(egg_info[EggGlobals.EGG_INFO_ID])
		new_egg_progress_bar.set_progress_bar_values(egg_info[EggGlobals.EGG_INFO_TOTAL_INCUBATION_TIME],
		egg_info[EggGlobals.EGG_INFO_INCUBATION_TIME_REMAINING])
		
		vbox_egg_progress.add_child(new_egg_progress_bar)
	
	# If multiple eggs, get existing eggs first
	else:
		var egg_children: Array = []
		for marker in texture_rect_nest.get_children():
			for child in marker.get_children():
				egg_children.append(child)
		
		
		# Get new markers to be used
		var markers: Array[Marker2D] = _get_markers(total_eggs)
		
		# Add existing eggs back to new markers
		# Remove children from markers and place in new markers
		var egg_index: int = 0
		for i in range(markers.size() - 1):
			var egg_child = egg_children[egg_index]
			egg_child.get_parent().remove_child(egg_child)
			markers[i].add_child(egg_child)
			egg_index += 1
		
		# Add new egg to final marker
		var new_egg_scene = egg_scene.instantiate()
		new_egg_scene.set_egg_id(egg_info[EggGlobals.EGG_INFO_ID])
		new_egg_scene.set_tooltip()
		var final_marker = markers[markers.size() - 1]
		
		final_marker.add_child(new_egg_scene)
		
		var new_egg_progress_bar = egg_progress_scene.instantiate()
		new_egg_progress_bar.set_egg_id(egg_info[EggGlobals.EGG_INFO_ID])
		new_egg_progress_bar.set_progress_bar_values(egg_info[EggGlobals.EGG_INFO_TOTAL_INCUBATION_TIME],
		egg_info[EggGlobals.EGG_INFO_INCUBATION_TIME_REMAINING])
		
		vbox_egg_progress.add_child(new_egg_progress_bar)
		


func on_egg_progress(egg_info: Dictionary) -> void:
	for child in vbox_egg_progress.get_children():
		if child.get_egg_id() == egg_info[EggGlobals.EGG_INFO_ID]:
			child.update_progress_bar(egg_info[EggGlobals.EGG_INFO_INCUBATION_TIME_REMAINING])
			return


func on_updated_egg(egg_info: Dictionary, total_eggs: int) -> void:
	for marker in texture_rect_nest.get_children():
		pass

################################################################################
################################ User Functions ################################
################################################################################

# Get all nest info, Place Eggs, instantiate progress bars
#func open(amount: int) -> void:
	#place_eggs(amount)
#
#
#func place_eggs(amount: int) -> void:
	#if amount < 1:
		#print("No Eggs to Place!!")
		#return
	#
	#var egg_placement_markers = egg_markers[amount - 1]


################################################################################
############################## Signal Functions ################################
################################################################################

func _on_lay_eggs_pressed() -> void:
	lay_eggs_pressed.emit()


func _on_close_window_pressed() -> void:
	hide()


################################################################################
############################## Utility Functions ###############################
################################################################################

func _get_markers(total_eggs: int):
	var markers
	
	match total_eggs:
		1:
			markers = one_egg_marker
		2:
			markers = two_egg_markers
		3:
			markers = three_egg_markers
		4:
			markers = four_egg_markers
		5:
			markers = five_egg_markers
		6:
			markers = six_egg_markers
	
	return markers


func _clear_markers() -> void:
	for marker in all_markers:
		for child in marker.get_children():
			child.queue_free()
