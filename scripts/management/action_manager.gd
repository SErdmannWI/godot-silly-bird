class_name ActionManager
extends Node

signal feed_bird(amount: int)

var action_queue: Array[Action] = []


# Adds action to the beginning of Array
func add_action(action: Action) -> void:
	action_queue.push_front(action)


func remove_action(action_id: String) -> void:
	for action: Action in action_queue:
		if (action.action_id == action_id):
			action_queue.erase(action)


# Performs specific action in the queue
# Determins type and calls appropriate function
func perform_action(action_id: String) -> void:
	var action_to_perform: Action
	
	for action: Action in action_queue:
		if (action.action_id == action_id):
			action_to_perform = action
			action_queue.erase(action)
	
	_match_action(action_to_perform)


# Performs next action
func perform_next_action() -> ManagerResponse:
	if action_queue.size() > 0:
		var action_to_perform: Action = action_queue.pop_front()
	
		return _match_action(action_to_perform)
	
	return null


func _perform_food_action(action: FoodAction) -> ManagerResponse:
	var food_amount: int = action.food_item.item_amount
	
	var response: ManagerResponse = ManagerResponse.new(ResponseCodes.ActionResponse.FEED_BIRD, "Feeding Bird", food_amount)
	
	remove_action(action.action_id)
	
	# Clear entity after action if needed
	if action.dispose_after_action:
		action.action_entity.queue_free()
	
	return response


# Matches action type to appropriate function
func _match_action(action: Action) -> ManagerResponse:
	match (action.action_type):
		GameGlobals.ActionType.FOOD:
			return _perform_food_action(action)
		_:
			return null
