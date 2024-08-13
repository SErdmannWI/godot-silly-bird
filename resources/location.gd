class_name Location
extends Resource

@export var location_name: String
@export_multiline var location_desc: String
@export var background: Texture2D
@export var location_id: String
@export var food_types: Array[FoodType]
# TODO Make this Array[Bird] when finished
@export var birds: Array[String]
# TODO make this Array[Threat] when finished
@export var threats: Array[String]
@export var threat_level: String
# TODO make this Array[PointOfInterst] when finished
@export var observations: Array[Observation]
@export var food_difficulty: float
@export var nest_material_needed: int = 1
