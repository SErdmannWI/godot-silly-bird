class_name SelectNestingUI
extends PanelContainer

signal nest_built
signal items_used(items: Array)

var nesting_items: Array[Item] = []
var amount_selected: int = 0
var amount_needed: int = 0

@onready var close_button: Button = %CloseButton
@onready var button_build_nest: Button = %BuildNestButton

@onready var item_list_nesting: ItemList = %SelectNestingItemList

@onready var label_amount_needed: Label = %AmountNeeded
@onready var label_amount_selected: Label = %AmountSelected
@onready var label_too_many_items: Label = %TooManyItemsLabel


func _ready() -> void:
	close_button.connect("pressed", _on_close_button_pressed)


# Show all nesting items in inventory
func open(player_nesting_items: Array[Item], needed: int) -> void:
	show()
	button_build_nest.disabled = true
	
	amount_needed = needed
	
	item_list_nesting.clear()
	
	label_amount_needed.text = str(amount_needed)
	label_amount_selected.text = str(0)
	nesting_items = player_nesting_items.duplicate(true)
	
	for item in nesting_items:
		item_list_nesting.add_item(item.item_name, item.item_icon, true)


func _update_ui():
	label_amount_selected.text = str(amount_selected)
	
	if amount_selected >= amount_needed:
		button_build_nest.disabled = false
	else:
		button_build_nest.disabled = true


# Resets amount selected, gets all selected items and updates amount
func _on_item_selected(_index: int, _selected: bool) -> void:
	label_amount_selected.text = ""
	amount_selected = 0
	
	var selected_items: Array = item_list_nesting.get_selected_items()
	
	for selection in selected_items:
		var item_selected: Item = nesting_items[selection]
		amount_selected += item_selected.item_amount
	
	
	_update_ui()


func _on_build_nest_button_pressed():
	label_too_many_items.visible = false
	
	var used_items: Array[Item] = _get_items_used()
	
	if _check_item_amount(used_items):
		label_too_many_items.visible = true
		return
	
	nest_built.emit()
	items_used.emit(used_items)
	
	hide()


func _get_items_used() -> Array[Item]:
	var used_items: Array[Item] = []
	var used_item_indecies: Array = item_list_nesting.get_selected_items()
	
	for index in used_item_indecies:
		var item_used: Item = nesting_items[index]
		used_items.append(item_used)
	
	#my_items.sort_custom(func(a, b): return a[0] > b[0])
	used_items.sort_custom(_sort_items)
	
	return used_items


# Checks if items selected and returns true if item_amount is greater than what is needed
func _check_item_amount(items_selected: Array) -> bool:
	var running_tally: int = 0
	
	for i in range(0, items_selected.size() - 1):
		running_tally += items_selected[i].item_amount
		if running_tally >= amount_needed:
			return true
	
	return false


func _sort_items(a: Item, b: Item) -> bool:
	if a.item_amount > b.item_amount:
		return true
	
	return false


func _on_close_button_pressed() -> void:
	hide()
