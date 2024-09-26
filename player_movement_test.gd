extends Node2D

var ground: Array[Vector2] = []
var x_min: float = -58
var x_max: float = 61
var y_min: float = 0
var y_max: float = 40

@onready var terrain: TileMap = %Terrain


func _ready():
	ground = _get_continuous_groud()
	_place_seeds()
	#var coords: Vector2 = Vector2(4, 33)
	#var coords2: Vector2 = Vector2(19, 30)
	#print(terrain.get_cell_tile_data(0, coords).get_custom_data("TopLayer"))
	#print(terrain.get_cell_tile_data(0, coords2).get_custom_data("TopLayer"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _get_continuous_groud() -> Array[Vector2]:
	var ground_array: Array[Vector2] = []
	for i in range(x_min, x_max):
		for j in range(y_min, y_max):
			var coord: Vector2 = Vector2(i, j)
			var data: TileData = terrain.get_cell_tile_data(0, coord)
			if data:
				if data.get_custom_data("TopLayer"):
					ground_array.append(coord)
					break
	
	return ground_array


func _get_tile_data(position: Vector2) -> TileData:
	var data: TileData = terrain.get_cell_tile_data(0, position)
	return data


# Place random seeds throughout the level
func _place_seeds() -> void:
	# Get number of seeds
	var number_of_seeds: int = randi_range(10, 20)
	# Get random x coords
	var x_coords: Array[float] = []
	for coords: Vector2 in ground:
		x_coords.append(coords.x)
	
	x_coords.shuffle()
	var seed_coords = x_coords.slice(0, number_of_seeds)
	
	# Match random x coords to appropriate ground coord
	for i in range(0, seed_coords.size()):
		for ground_coord: Vector2 in ground:
			if (ground_coord.x == seed_coords[i]):
				# Add seeds
				terrain.set_cell(0, Vector2(ground_coord.x, ground_coord. y - 1), 1, Vector2i.ZERO, 1)
