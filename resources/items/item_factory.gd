class_name ItemFactory
extends Node

# Dictionary to store loaded item resources
var item_templates: Dictionary = {}
var path_array: Array[String] = [
	"res://resources/items/item_type_food/",
	"res://resources/items/item_type_nesting/",
	"res://resources/items/item_type_valuables/",
	]

func _ready():
	load_item_templates()


func load_item_templates():
	for path in path_array:
		var dir = DirAccess.open(path)
		
		if dir:
			dir.list_dir_begin()
			var file_name = dir.get_next()
			
			while file_name != "" and !dir.current_is_dir():
				var item = load(path + file_name) as Item
				item_templates[item.item_id] = item
				file_name = dir.get_next()
		else:
			print("Error!")


func create_item(item_id: String) -> Item:
	if item_templates.has(item_id):
		var item = item_templates[item_id].duplicate()
		return item
	
	return null


func get_random_item() -> Item:
	var keys: Array = item_templates.keys()
	var max_index: int = item_templates.size() - 1
	var index = randi_range(0, max_index)
	
	return item_templates[keys[index]]
