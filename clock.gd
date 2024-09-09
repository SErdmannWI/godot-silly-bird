# Clock display to be used in game.
extends TextureRect

var cycles: int
# Assuming 5 minute days or 300 seconds, cycle multiplier is 180(degrees of rotation) * 300 (day cycle seconds)
const CYCLE_MULTIPLIER: float = 0.6

var rotation_speed: float = 0.0
var acceleration: float = 0.5
var max_rotation_speed: float = 1.0

# Arrow should start at "6 a.m." so set back 90 degrees (noon is 0.0)
const ARROW_OFFSET: float = -90.0
var target_rotation: float = 0.0
var reached_target: bool = true

@onready var arrow: TextureRect = %ArrowTextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	arrow.rotation = deg_to_rad(ARROW_OFFSET)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not reached_target:
		_increment_arrow(delta)


func on_time_incremented(current_cycle: int) -> void:
	cycles = current_cycle
	reached_target = false


func _increment_arrow(delta: float) -> void:
	var current_rotation: float = arrow.rotation
	var desired_rotation: float = deg_to_rad(cycles * CYCLE_MULTIPLIER + ARROW_OFFSET)
	var difference: float = desired_rotation - current_rotation
	
	if abs(difference) < 0.01:
		reached_target = true
		rotation_speed = 0
		return
	
	rotation_speed = clamp(difference * acceleration, -max_rotation_speed, max_rotation_speed)
	arrow.rotation += rotation_speed * delta
	
