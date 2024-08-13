extends Node2D

# HTTP Requests
@onready var get_all_request:HTTPRequest = %GetAllRequest
@onready var post_request:HTTPRequest = %PostRequest
@onready var get_request:HTTPRequest = %GetRequest
@onready var delete_request:HTTPRequest = %DeleteRequest
@onready var put_request:HTTPRequest = %PutRequest

# Create entry
@onready var name_edit:TextEdit = %NameEdit
@onready var id_edit:TextEdit = %IDEdit
@onready var response_message_label:Label = %ResponseMessageLabel
@onready var new_entry_name:Label = %NewEntryName
@onready var new_entry_id:Label = %NewEntryID

# Get all entries
@onready var results_header:Label = %ResultsHeader
@onready var total_results_number:Label = %ResultsNumber
@onready var entry_number:Label = %EntryNumber
@onready var entry_name:Label = %Name
@onready var entry_id:Label = %ID
@onready var delete_all_popup = %DeleteAllPopup

# Modify entry by ID
@onready var operation_button:OptionButton = %OptionButton
@onready var entered_id:TextEdit = %TextEdit
@onready var modify_entry_message = %ModifyEntryMessage
@onready var select_option_prompt:Label = %SelectOptionPrompt
@onready var request_name:Label = %EntryName
@onready var request_id:Label = %EntryID

# Edit entry
@onready var results_response_label = %ResultsResponseMessage
@onready var edit_button = %EditButton
@onready var edit_submit_button = %EditSubmitButton
@onready var name_line_edit = %NameLineEdit

const success_message:String = "Successfully created new record!"
const empty_name_field_message:String = "Name field cannot be empty."
const empty_id_field_message:String = "ID field cannot be empty."
const entry_failure_message:String = "Error creating new record! Response code: "
const get_failure_message:String = "Record not found with ID: "
const edit_success_message:String = "Success!"

const get_all_url = "http://localhost:8080/test/all"
const submit_test_url = "http://localhost:8080/test/newTest"
const get_by_id_url = "http://localhost:8080/test/"
const delete_all_url = "http://localhost:8080/test/deleteAll"
const edit_url = "http://localhost:8080/test/edit"
const headers = ["Content-Type: application/json"]

var entries:Array = []
var index:int = 0
var new_entry:Dictionary = {}
var get_entry:Dictionary = {}

# Connect HTTPRequests with functions
func _ready():
	post_request.request_completed.connect(_on_post_request_complete)
	get_all_request.request_completed.connect(_on_get_all_request_completed)
	get_request.request_completed.connect(_on_get_by_id_request_complete)
	delete_request.request_completed.connect(_on_delete_request_complete)
	put_request.request_completed.connect(_on_put_request_complete)
	
	edit_button.connect("pressed", _on_edit_button_pressed.bind())
	edit_submit_button.connect("pressed", _on_edit_submit_button_pressed.bind())


# Request Submissions
# New test records
func submit_new_test_request():
	var submit_request = {'id' : id_edit.text.strip_edges(), 'name' : name_edit.text.strip_edges()}
	var json = JSON.stringify(submit_request)
	
	post_request.request(submit_test_url, headers, HTTPClient.METHOD_POST, json)

# New Test response
func _on_post_request_complete(results, response_code, headers, body):
	if response_code != 200:
		var json:JSON = JSON.new()
		var error = json.parse(body.get_string_from_utf8())
		if error == OK:
			var response = json.data
			response_message_label.visible = true
			response_message_label.set("theme_override_colors/font_color", Color.RED)
			response_message_label.text = response["errorMessage"]
			return
	
	var json:JSON = JSON.new()
	var error = json.parse(body.get_string_from_utf8())
	if error == OK:
		var result = json.data
		
		if typeof(result) == TYPE_DICTIONARY:
			new_entry = result
			_update_create_display()
	else:
		response_message_label.text = entry_failure_message

# Get all test records
func send_request_get_all():
	get_all_request.request(get_all_url, headers, HTTPClient.METHOD_GET)

# Process response for get all
func _on_get_all_request_completed(results, response_code, headers, body):
	print(response_code)
	
	var json:JSON = JSON.new()
	var error = json.parse(body.get_string_from_utf8())
	if error == OK:
		var result = json.data
		
		if typeof(result) == TYPE_ARRAY:
			entries = json.data
			
			if entries.size() > 0:
				index = 0
				_update_get_all_display()
			else:
				print("Error: no data available")
		elif typeof(result) == TYPE_DICTIONARY:
			pass
	else:
		print("Error getting data with status code " + str(error))

# Get record by ID
func get_record_by_id_request():
	var request_url:String = get_by_id_url + str(entered_id.text)
	get_request.request(request_url, headers, HTTPClient.METHOD_GET)

# Process response from get by id request
func _on_get_by_id_request_complete(results, response_code, headers, body):
	var json:JSON = JSON.new()
	var error = json.parse(body.get_string_from_utf8())
	if error == OK:
		var response = json.data
		
		if !response_code == 200:
			modify_entry_message.visible = true
			modify_entry_message.set("theme_override_colors/font_color", Color.RED)
			modify_entry_message.text = response["errorMessage"]
			return
		
		if typeof(response) == TYPE_DICTIONARY:
			get_entry = response
			_update_get_display()
		else:
			print("Error getting entry")

# Delete record by ID
func delete_record_by_id_request():
	var request_url:String = get_by_id_url + str(entered_id.text)
	delete_request.request(request_url, headers, HTTPClient.METHOD_DELETE)

func _on_delete_request_complete(results, response_code, headers, body):
	if response_code == 204:
			print("Here!")
			results_header.visible = true
			results_header.set("theme_override_colors/font_color", Color.GREEN)
			results_header.text = "All records deleted"
			_clear_ui()
			return
	
	var json:JSON = JSON.new()
	var error = json.parse(body.get_string_from_utf8())
	if error == OK:
		var response = json.data
		if response_code == 404:
			modify_entry_message.visible = true
			modify_entry_message.set("theme_override_colors/font_color", Color.RED)
			modify_entry_message.text = response["error"]
			return
			
		elif !response_code == 200:
			print(str(response))
			modify_entry_message.visible = true
			modify_entry_message.set("theme_override_colors/font_color", Color.RED)
			modify_entry_message.text = response["errorMessage"]
			return
		
		modify_entry_message.visible = true
		modify_entry_message.set("theme_override_colors/font_color", Color.GREEN)
		modify_entry_message.text = "Record with ID " + str(response["id"]) + " successfully deleted"

# Delete all records
func delete_all_records():
	delete_request.request(delete_all_url, headers,HTTPClient.METHOD_DELETE)

# Edit record
func edit_record_request():
	var submit_request = {'id' : entry_id.text.strip_edges(), 'name' : name_line_edit.text.strip_edges()}
	var json = JSON.stringify(submit_request)
	
	put_request.request(edit_url, headers, HTTPClient.METHOD_PUT, json)

func _on_put_request_complete(results, response_code, headers, body):
	if response_code != 200:
		var json:JSON = JSON.new()
		var error = json.parse(body.get_string_from_utf8())
		if error == OK:
			var response = json.data
			response_message_label.visible = true
			response_message_label.set("theme_override_colors/font_color", Color.RED)
			response_message_label.text = response["errorMessage"]
			return
	
	var json:JSON = JSON.new()
	var error = json.parse(body.get_string_from_utf8())
	if error == OK:
		var result = json.data
		
		if typeof(result) == TYPE_DICTIONARY:
			get_entry = result
			_update_get_display()
	else:
		results_response_label.text = entry_failure_message


# UI Functions
# Clears center UI
func _clear_ui():
	total_results_number.text = ""
	entry_number.text = ""
	entry_name.text = ""
	entry_id.text = ""

# Updates UI for Get Request
func _update_get_display():
	results_response_label.text = edit_success_message
	results_response_label.set("theme_override_colors/font_color", Color.GREEN)
	request_name.visible = true
	name_line_edit.visible = false
	request_name.text = get_entry["name"]
	request_id.text = get_entry["id"]

func _update_get_display_edit():
	request_name.visible = false
	name_line_edit.text = request_name.text
	name_line_edit.visible = true

# Updates UI elements with current entry
func _update_get_all_display():
	total_results_number.text = str(entries.size())
	entry_number.text = str(index + 1)
	entry_name.text = entries[index]["name"]
	entry_id.text = entries[index]["id"]

# Update create display
func _update_create_display():
	response_message_label.visible = true
	response_message_label.set("theme_override_colors/font_color", Color.GREEN)
	response_message_label.text = success_message
	new_entry_name.text = new_entry["name"]
	new_entry_id.text = new_entry["id"]

# Signal Functions
func _on_button_pressed():
	submit_new_test_request()

func _on_get_all_button_pressed():
	send_request_get_all()

func _on_clear_button_pressed():
	_clear_ui()

func _on_edit_button_pressed():
	_update_get_display_edit()

func _on_edit_submit_button_pressed():
	edit_record_request()

func _on_last_entry_button_pressed():
	if index == 0:
		index = entries.size() - 1
		_update_get_all_display()
	else:
		index -= 1
		_update_get_all_display()

func _on_next_entry_button_pressed():
	if index == (entries.size() - 1):
		index = 0
		_update_get_all_display()
	else:
		index += 1
		_update_get_all_display()

func _on_submit_button_pressed():
	if entered_id.text.strip_edges().length() == 0:
		modify_entry_message.visible = true
		modify_entry_message.set("theme_override_colors/font_color", Color.RED)
		modify_entry_message.text = "ID Field cannot be blank."
		return
	if operation_button.selected == 1:
		select_option_prompt.visible = false
		get_record_by_id_request()
	elif operation_button.selected == 2:
		select_option_prompt.visible = false
		delete_record_by_id_request()
	else :
		select_option_prompt.visible = true

func _on__delete_all_button_pressed():
	delete_all_popup.popup_centered()
	delete_all_popup.visible = true

func _on_delete_all_popup_confirmed():
	delete_all_records()
