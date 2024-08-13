extends Popup

@onready var item_debug_v_box:VBoxContainer = %ItemDebugVBox


func _ready():
	for item_name in ITEM_FACTORY.item_templates.keys():
		var button: Button = Button.new()
		button.text = item_name
		#button.connect("pressed", _add_item)
		button.pressed.connect(_add_item.bind(button.text))
		
		item_debug_v_box.add_child(button)


func _add_item(item_name) -> void:
	#MainBird.inventory.add_item(ITEM_FACTORY.create_item(item_name))
	Director.on_add_item(item_name)
	hide()
