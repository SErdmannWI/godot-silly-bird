extends Popup

@onready var confirm_quit_button:Button = %ConfrimQuitButton
@onready var cancel_button:Button = %CancelButton

signal quit_program

# Called when the node enters the scene tree for the first time.
func _ready():
	confirm_quit_button.connect("pressed", _on_quit_button_pressed.bind())
	cancel_button.connect("pressed", _on_cancel_button_pressed.bind())


func _on_quit_button_pressed():
	quit_program.emit()

func _on_cancel_button_pressed():
	visible = false
