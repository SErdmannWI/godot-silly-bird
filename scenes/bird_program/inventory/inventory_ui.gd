class_name InventoryUI
extends PanelContainer

@export var item_type_vbox: PackedScene
@export var item_slot_scene: PackedScene

@onready var close_button: Button = %CloseButton
@onready var inventory_grid_h_box:HBoxContainer = %InventoryGridHBox

func _ready():
	close_button.connect("pressed", _on_close_button_pressed)
	#var test_slot = item_slot_scene.instantiate()
	#var test_box = item_type_vbox.instantiate()


# Clears inventory, then adds HBox for each type, each type having its own GridContainer
func open(inventory: Inventory):
	show()
	
	for child in inventory_grid_h_box.get_children():
		child.queue_free()
	
	for item_type_name in inventory.get_items_sorted().keys():
		var item_vbox_instance = item_type_vbox.instantiate()
		item_vbox_instance.call_deferred("display_item_type", item_type_name)
		#item_vbox_instance.display_item_type(type.type_name)
		inventory_grid_h_box.add_child(item_vbox_instance)
		
		for item in inventory.get_items_sorted()[item_type_name]:
			var item_slot = item_slot_scene.instantiate()
			item_vbox_instance.item_grid_container.add_child(item_slot)
			item_slot.display_item(item)


func _on_close_button_pressed() -> void:
	hide()
