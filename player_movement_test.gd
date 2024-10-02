extends Node2D

var seed_scene: PackedScene = preload("res://scenes/bird_program/food/seeds.tscn")

var ground: Array[Vector2] = []
var x_min: float = -58
var x_max: float = 61
var y_min: float = 0
var y_max: float = 40

var tree_clusters: Dictionary = {}
var visited: Dictionary = {}

@onready var terrain: TileMap = %Terrain


func _ready():
	ground = _get_continuous_groud()
	_place_seeds()
	_identify_trees()
	
	Director.start_new_day()


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
	var seed_coords: Array[float] = x_coords.slice(0, number_of_seeds)
	
	# Match random x coords to appropriate ground coord
	for i in range(0, seed_coords.size()):
		for ground_coord: Vector2 in ground:
			if (ground_coord.x == seed_coords[i]):
				# Add seeds
				terrain.set_cell(0, Vector2(ground_coord.x, ground_coord. y - 1), 1, Vector2i.ZERO, 1)


func _identify_trees() -> void:
		for i in range(x_min, x_max):
			for j in range(y_min, y_max):
				var position: Vector2 = Vector2(i, j)
				if position in visited:
					continue
				var data: TileData = terrain.get_cell_tile_data(0, position)
				if data and data.get_custom_data("is_tree"):
					var cluster: Array = []
					_flood_fill(position, cluster)
					var tree_id: String = GameGlobals.generate_uuid()
					tree_clusters[tree_id] = cluster


func _flood_fill(position: Vector2, cluster: Array) -> void:
	var stack: Array[Vector2] = [position]
	while stack.size() > 0:
		var current: Vector2 = stack.pop_back()
		if current in visited:
			continue
		visited[current] = true
		var data: TileData = terrain.get_cell_tile_data(0, current)
		if data and data.get_custom_data("is_tree"):
			cluster.append(current)
			for neighbor in _get_neighbors(current):
				var neighbor_data = terrain.get_cell_tile_data(0, neighbor)
				if neighbor_data and neighbor_data.get_custom_data("is_tree"):
					stack.append(neighbor)


func _get_neighbors(position: Vector2) -> Array:
	var neighbors = []
	var directions = [
		Vector2(1, 0),
		Vector2(-1, 0),
		Vector2(0, 1),
		Vector2(0, -1)
	]
	
	for dir in directions:
		var neighbor_pos = position + dir
		
		if neighbor_pos.x >= x_min and neighbor_pos.x < x_max and neighbor_pos.y >= y_min and neighbor_pos.y < y_max:
			neighbors.append(neighbor_pos)
	
	return neighbors
	
