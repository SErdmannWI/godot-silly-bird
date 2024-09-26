class_name Action

var action_id: String
var action_type
var action_entity
var dispose_after_action: bool


func _init(entity, dispose_after_action) -> void:
	action_id = GameGlobals.generate_uuid()
	action_entity = entity
	self.dispose_after_action = dispose_after_action
