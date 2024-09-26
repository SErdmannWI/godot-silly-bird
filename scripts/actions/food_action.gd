class_name FoodAction
extends Action

var food_item: Item

var food_id: String
var can_inventory: bool


func _init(entity, dispose_after_action: bool, item_id: String, can_inventory: bool) -> void:
	super(entity, dispose_after_action)
	action_type = GameGlobals.ActionType.FOOD
	food_id = item_id
	food_item = ITEM_FACTORY.create_item(food_id)
	self.can_inventory = can_inventory
