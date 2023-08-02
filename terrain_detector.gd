extends Area2D
class_name TerrainDetector

@export var data_layer_name = ""
@export var current_tilemap: TileMap = null
@export var check_tilemap_layers = [1]

enum TerrainType {
	UNDERWATER = 1,
	SURFACE = 2,
	SHALLOW = 4,
	DEEP = 8,
	WET = 16,
	SAND = 32,
	GRASS = 64,
	WOOD = 128
}

var previous_terrain: int = -1
var current_terrain: int = -1
var previous_tile_coords = Vector2i.ZERO

signal terrain_entered(terrain_type)
signal tile_coords_updated(coords)


func _ready():
	connect("tile_coords_updated", _on_tile_coords_updated)
	if !current_tilemap:
		set_physics_process(false)


func _exit_tree() -> void:
	current_tilemap = null
	current_terrain = -1


func _physics_process(delta):
	if !current_tilemap:
		return
	var tile_coords = current_tilemap.local_to_map(global_position)
	if tile_coords != previous_tile_coords:
		previous_tile_coords = tile_coords
		emit_signal("tile_coords_updated", tile_coords)


func _on_tile_coords_updated(coords: Vector2i):
	for index in check_tilemap_layers:
		var tile_data = current_tilemap.get_cell_tile_data(index, coords)
		var terrain_mask = 0
		if tile_data is TileData:
			terrain_mask = tile_data.get_custom_data(data_layer_name) if data_layer_name else -1
		_update_terrain(terrain_mask)


func _update_terrain(terrain_mask: int) -> void:
	if terrain_mask != current_terrain:
		previous_terrain = current_terrain
		current_terrain = terrain_mask
		emit_signal("terrain_entered", current_terrain)


func _on_body_shape_entered(body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is TileMap:
		current_tilemap = body
		set_physics_process(true)
