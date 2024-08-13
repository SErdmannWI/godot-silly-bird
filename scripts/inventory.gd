class_name Inventory

signal change_to_ui(item_type: String, new_amount: int)

var _items: Array[Item] = []


func get_inventory() -> Array[Item]:
	return _items


func add_item(item: Item):
	_items.append(item)
	_on_inventory_change(item.item_type.type_name)


func add_item_by_name(item_name: String):
	var item: Item = ITEM_FACTORY.create_item(item_name)
	_items.append(item)


func remove_item(item: Item):
	_items.erase(item)
	_on_inventory_change(item.item_type.type_name)


func remove_item_by_name(item_name: String) -> void:
	for item in _items:
		if item.item_name == item_name:
			_items.erase(item)
			return


func get_item_by_name(item_name: String) -> Item:
	for item in _items:
		if item.item_name == item_name:
			return item.duplicate()
		
	return null


func get_items_sorted() -> Dictionary:
	var items_by_type: Dictionary = {}
	
	for item in _items:
		if item.item_type.type_name not in items_by_type:
			items_by_type[item.item_type.type_name] = []
		items_by_type[item.item_type.type_name].append(item)
	
	return items_by_type


# Gets all Items of type nesting material. Called by Select Nesting UI
func get_all_nesting_items() -> Array[Item]:
	var nesting_items: Array[Item] = []
	
	for item: Item in _items:
		if item.item_type.type_name == ItemGlobals.ITEM_TYPE_NESTING:
			nesting_items.append(item)
	
	return nesting_items


# Called by player_bird can_build_nest
# Checks that item_type is in inventory, returns number of that item_type. Otherwise, returns 0
func get_item_type_amount(item_type: String) -> int:
	var item_dictionary: Dictionary = get_items_sorted()
	
	if item_type not in item_dictionary:
		return 0
	
	var item_amount: int = 0
	
	for item in item_dictionary[item_type]:
		item_amount += item.item_amount
	
	return item_amount


# Gets the item type that was changed and gets amount for each item
func _on_inventory_change(item_type: String) -> void:
	var item_dictionary: Dictionary = get_items_sorted()
	var new_amount: int = 0
	
	if item_type not in item_dictionary:
		change_to_ui.emit(item_type, 0)
	
	else:
		for item in item_dictionary[item_type]:
			new_amount += item.item_amount
		
		change_to_ui.emit(item_type, new_amount)
