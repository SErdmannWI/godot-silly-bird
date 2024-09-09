class_name InventoryManager
extends Node

var inventory: Inventory

func _init():
	# TODO Replace assignment to actual Player bird when implemented
	inventory = Inventory.new()


func start_new_day() -> void:
	pass


func end_day() -> void:
	print("Inventory Manager: ending day")


func get_inventory() -> Inventory:
	return inventory


func add_item(item_name: String) -> void:
	inventory.add_item(ITEM_FACTORY.create_item(item_name))


func use_items(items_used: Array[Item]) -> void:
	for item in items_used:
		inventory.remove_item(item)


func get_nesting_items() -> Array[Item]:
	return inventory.get_all_nesting_items()


func can_build_nest(material_needed: int) -> bool:
	if (material_needed > inventory.get_item_type_amount(ItemGlobals.ITEM_TYPE_NESTING)):
		return false
	
	return true
