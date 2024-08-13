extends Popup


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Hides popup on button press
func _on_confirm_button_pressed():
	visible = false
