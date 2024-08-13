extends TextureRect

var _egg_id: String


func _ready():
	position.x = -20
	position.y = -22


func set_egg_id(new_egg_id: String) -> void:
	_egg_id = new_egg_id


func get_egg_id() -> String:
	return _egg_id


func set_tooltip() -> void:
	tooltip_text = _egg_id
