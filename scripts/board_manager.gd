#class_name BoardManager
extends Node2D

const TILE_SIZE := 16

@onready var water_layer = $LevelCreator/Water

var occupied_tiles: Dictionary = {}


func register_entity(entity, grid_pos: Vector2i) -> void:
	occupied_tiles[grid_pos] = entity


func unregister_entity(grid_pos: Vector2i) -> void:
	occupied_tiles.erase(grid_pos)


func is_tile_occupied(grid_pos: Vector2i) -> bool:
	return occupied_tiles.has(grid_pos)


func get_entity_at(grid_pos: Vector2i):
	return occupied_tiles.get(grid_pos, null)


func move_entity(entity, new_pos: Vector2i) -> bool:

	# Something already there?
	if is_tile_occupied(new_pos):

		var occupying_entity = get_entity_at(new_pos)

		# Platforms are walkable
		if not occupying_entity.is_platform:
			return false

	# Remove old position
	occupied_tiles.erase(entity.grid_pos)

	# Update entity
	entity.grid_pos = new_pos

	# Add new position
	occupied_tiles[new_pos] = entity

	# Move visuals
	entity.move_to_grid()

	# Handle terrain effects
	handle_landing(entity, new_pos)

	return true


func try_move(entity, direction: Vector2i) -> bool:
	var target_pos: Vector2i = entity.grid_pos + direction

	return move_entity(entity, target_pos)


func try_push(entity, direction: Vector2i) -> bool:

	var target_pos: Vector2i = entity.grid_pos + direction * 2

	var object = get_entity_at(target_pos)

	if object == null:
		return false

	if object.can_be_moved == false:
		return false

	var object_new_pos: Vector2i = object.grid_pos + direction

	return move_entity(object, object_new_pos)


func try_pull(entity, direction: Vector2i) -> bool:

	var target_pos: Vector2i = entity.grid_pos + direction * 2

	var object = get_entity_at(target_pos)

	if object == null:
		return false

	if object.can_be_moved == false:
		return false

	var object_new_pos: Vector2i = object.grid_pos - direction

	return move_entity(object, object_new_pos)


func handle_landing(entity, pos: Vector2i):

	if is_water_tile(pos):

		entity.on_enter_water()


func is_water_tile(pos: Vector2i) -> bool:

	var cell = water_layer.get_cell_tile_data(pos)

	return cell != null
