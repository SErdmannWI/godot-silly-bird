extends Node2D

@onready var login_popup = %LoginPopup
@onready var quit_popup = %QuitPopup

@onready var bird_program_button = %BirdProgramButton
@onready var test_program_button = %TestProgramButton
@onready var settings_button = %SettingsButton
@onready var quit_button = %QuitButton


# Called when the node enters the scene tree for the first time.
func _ready():
	test_program_button.connect("pressed", _on_test_program_button_pressed.bind())
	quit_button.connect("pressed", _on_quit_button_pressed.bind())
	quit_popup.quit_program.connect(_quit_program)


# Button functions
func _on_login_link_clicked():
	login_popup.visible = true

func _on_bird_program_button_pressed():
	pass

func _on_test_program_button_pressed():
	get_tree().change_scene_to_file("res://scenes/test_program/test.tscn")

func _on_settings_button_pressed():
	pass

func _on_quit_button_pressed():
	quit_popup.visible = true


func _quit_program():
	get_tree().quit()
