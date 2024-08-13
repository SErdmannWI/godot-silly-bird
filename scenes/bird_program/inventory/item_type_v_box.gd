extends VBoxContainer

@onready var item_type_header: Label = %ItemTypeHeader
@onready var item_grid_container: GridContainer = %ItemGridContainer


func display_item_type(type: String) -> void:
	item_type_header.text = type
