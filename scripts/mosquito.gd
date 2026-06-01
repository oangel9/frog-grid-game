class_name Mosquito
extends Node2D

const TILE_SIZE := 16
const HALF_TILE := Vector2(TILE_SIZE / 2, TILE_SIZE / 2)

@onready var board = get_parent().get_parent()

var grid_pos: Vector2i

var is_platform := false
var can_be_moved := true
var can_be_eaten := true


func _ready():
	grid_pos = Vector2i(
		floor(position.x / TILE_SIZE),
		floor(position.y / TILE_SIZE)
	)

	move_to_grid()

	board.register_entity(self, grid_pos)


func move_to_grid():
	position = Vector2(grid_pos) * TILE_SIZE + HALF_TILE


func on_enter_water():
	board.unregister_entity(grid_pos)
	board.register_platform_on_water(self, grid_pos)																																									
