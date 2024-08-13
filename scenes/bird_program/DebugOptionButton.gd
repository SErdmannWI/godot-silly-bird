extends OptionButton

signal change_hunger(amount:int)
signal change_energy(amount:int)
signal change_social(amount:int)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func on_item_selected(index:int) -> void:
	match index:
		0:
			emit_signal("change_hunger", 10)
		1:
			emit_signal("change_hunger", 100)
		2:
			emit_signal("change_social", 10)
		3:
			emit_signal("change_social", 100)
		4:
			emit_signal("change_energy", 10)
		5:
			emit_signal("change_energy", 100)
		6:
			emit_signal("change_hunger", -100)
			emit_signal("change_energy", -100)
			emit_signal("change_social", -100)
		_:
			print("Unknown debug selection: " + str(index))
