extends Label

const MOOD_HAPPY:String = "Happy"
const MOOD_HUNGRY:String = "Hungry"
const MOOD_FULFILLED:String = "Fulfilled"
const MOOD_LONELY:String = "Lonely"
const MOOD_ANNOYED:String = "Annoyed"
const MOOD_SLEEPY:String = "Sleepy"
const MOOD_ANGRY:String = "Angry"

var is_hungry:bool
var is_happy:bool
var is_fulfilled:bool
var is_lonely:bool
var is_annoyed:bool
var is_sleepy:bool
var is_angry:bool

# Called when the node enters the scene tree for the first time.
func _ready():
	text = MOOD_HAPPY


func _mood_check() -> void:
	if _anger_check():
		text = MOOD_ANGRY
		return
	elif is_hungry:
		text = MOOD_HUNGRY
		return
	elif is_sleepy:
		text = MOOD_SLEEPY
		return
	elif is_lonely:
		text = MOOD_LONELY
		return
	elif is_annoyed:
		text = MOOD_ANNOYED
		return
	elif is_fulfilled:
		text = MOOD_FULFILLED
		return
	
	text = MOOD_HAPPY

func _anger_check() -> bool:
	var negative_conditions:Array = [is_hungry, is_lonely, is_sleepy, is_annoyed]
	var true_count:int = 0
	
	for condition in negative_conditions:
		if condition:
			true_count += 1
	
	is_angry = true_count >= 2
	return is_angry

func on_high_hunger() -> void:
	is_hungry = true
	_mood_check()

func on_satisfied_hunger() -> void:
	is_hungry = false
	_mood_check()

func on_lonely() -> void:
	is_lonely = true
	_mood_check()

func on_not_lonely() -> void:
	is_lonely = false
	_mood_check()

func on_annoyed() -> void:
	is_annoyed = true
	_mood_check()

func on_not_annoyed() -> void:
	is_annoyed = false
	_mood_check()

func on_sleepy() -> void:
	is_sleepy = true
	_mood_check()

func on_not_sleepy() -> void:
	is_sleepy = false
	_mood_check()
