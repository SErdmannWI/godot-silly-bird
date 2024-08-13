class_name Bird
extends CharacterBody2D

@export var bird_name:String
@export var image:String
@export var age:int
@export var food_type: String
@export var behavior: String

var mood:String
var hunger_level:float
var social_level:float
var energy_level:float

# Max variables
var hunger_level_max:float
var social_level_max:float
var energy_level_max:float


# Called when the node enters the scene tree for the first time.
func _ready():
	age = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Bird Functions
func age_up() -> void:
	age += 1

func feed_bird(food_amount:int) -> void:
	hunger_level += food_amount

func refill_social(social_amount:int) -> void:
	social_level += social_amount
