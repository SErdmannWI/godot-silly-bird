extends Sprite2D

@onready var arrow: Sprite2D = %Arrow
@onready var button_increase: Button = %ButtonIncrease
@onready var button_decrease: Button = %ButtonDecrease
@onready var value_input: TextEdit = %ValueInput
@onready var button_submit: Button = %ButtonSubmit
@onready var label_current_rotation: Label = %CurrentRotation

var rotation_speed: float = 0.0
var acceleration: float = 1.0
var max_roatation_speed: float = 5.0
var deceleration: float = 8.0

var target_rotation: float = 0.0
var reached_target: bool = true

func _ready():
	button_submit.pressed.connect(_on_submit)

func _process(delta):
	label_current_rotation.text = str(rad_to_deg(arrow.rotation))
	
	if not reached_target:
		_rotate_towards_target(delta)
	
	if button_increase.is_pressed():
		_increase_value(delta)
	elif button_decrease.is_pressed():
		_decrease_value(delta)
	else:
		_apply_deceleration(delta)


func _increase_value(delta: float) -> void:
	rotation_speed += acceleration * delta
	rotation_speed = clamp(rotation_speed, -max_roatation_speed, max_roatation_speed)
	arrow.rotation += rotation_speed * delta
	


func _decrease_value(delta: float) -> void:
	rotation_speed -= acceleration * delta
	rotation_speed = clamp(rotation_speed, -max_roatation_speed, max_roatation_speed)
	arrow.rotation += rotation_speed * delta


func _apply_deceleration(delta: float) -> void:
	if rotation_speed > 0:
		rotation_speed -= deceleration * delta
	elif rotation_speed < 0:
		rotation_speed += deceleration * delta
	
	if abs(rotation_speed) < 0.1:
		rotation_speed = 0.0
	
	arrow.rotation += rotation_speed * delta


func _on_submit() -> void:
	print("Pressed")
	var input_value: float = value_input.text.to_float()
	print(str(input_value))
	target_rotation = deg_to_rad(input_value) # Convert degrees to radians
	reached_target = false # reset the flag


func _rotate_towards_target(delta: float) -> void:
	var current_rotation: float = arrow.rotation
	var difference: float = target_rotation - current_rotation
	
	# Check if we're close enough to the target to stop
	if abs(difference) < 0.1:
		reached_target = true
		rotation_speed = 0.0
		return
	
	# Speed is proportional to the distance to the target
	rotation_speed = clamp(difference * acceleration, -max_roatation_speed, max_roatation_speed)
	
	arrow.rotation += rotation_speed * delta
