class_name ManagerResponse
extends Node

var response_code: int
var response_message: String
var body: Variant = null

func _init(response_code: int, response_message: String, body: Variant = null) -> void:
	self.response_code = response_code
	self.response_message = response_message
	self.body = body
	
