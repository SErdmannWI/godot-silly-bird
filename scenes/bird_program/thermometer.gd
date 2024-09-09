# Thermometer display to be used in game.
extends TextureRect

# Using farenheit
var temperature: int = 0
# Assuming 80 degrees per half circle, degree multiplier is 180(degrees of rotation) / 80 (number of degrees)
const DEGREE_MULTIPLIER: float = 2.25

var rotation_speed: float = 0.0
var acceleration: float = 0.5
var max_rotation_speed: float = 1.0

# 
const ARROW_OFFSET: float = -135.0
var target_rotation: float = 0.0
var reached_target: bool = true

@onready var arrow: TextureRect = %TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	arrow.rotation = deg_to_rad(ARROW_OFFSET)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not reached_target:
		_increment_arrow(delta)


func on_temperature_changed(current_temp: int) -> void:
	temperature = current_temp
	reached_target = false


func _increment_arrow(delta: float) -> void:
	var current_rotation: float = arrow.rotation
	var desired_rotation: float = deg_to_rad(temperature * DEGREE_MULTIPLIER + ARROW_OFFSET)
	var difference: float = desired_rotation - current_rotation
	
	if abs(difference) < 0.01:
		reached_target = true
		rotation_speed = 0
		return
	
	rotation_speed = clamp(difference * acceleration, -max_rotation_speed, max_rotation_speed)
	arrow.rotation += rotation_speed * delta
