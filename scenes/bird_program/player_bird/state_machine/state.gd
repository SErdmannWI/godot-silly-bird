class_name State
extends Node

@export var sibling_state: State
@export var animation_name: String

var gravity: int = GameGlobals.PHYSICS_GRAVITY
var speed: int = GameGlobals.PHYSICS_BASE_SPEED
var acceleration: int = GameGlobals.PHYSICS_BASE_ACCELERATION
var friction: int = GameGlobals.PHYSICS_BASE_FRICTION

var gravity_multiplier: float = 1.0

var parent: TestPlayerBirdAvatar


# TODO Replace with animations when needed
func enter() -> void:
	pass


func exit() -> void:
	pass


func process_input(event: InputEvent) -> State:
	return null


func process_physics(delta: float) -> State:
	return null


func process_frame(delta: float) -> State:
	return null
