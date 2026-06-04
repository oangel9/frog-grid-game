class_name BrokenLog
extends Node2D

const TILE_SIZE := 16
const HALF_TILE := Vector2(TILE_SIZE / 2, TILE_SIZE / 2)

@onready var board = get_parent().get_parent()

var grid_pos: Vector2i

var is_platform := true
var can_be_moved := false
var can_be_eaten := false
var breaking_point := 1

func _ready():
	grid_pos = Vector2i(
		floor(position.x / TILE_SIZE),
		floor(position.y / TILE_SIZE)
	)

	move_to_grid()
	board.register_entity(self, grid_pos)


func move_to_grid():
	position = Vector2(grid_pos) * TILE_SIZE + HALF_TILE

		#board.on_enter_water()
	#else:
		#board.register_entity(self, grid_pos)

func on_start_water():
	is_platform = true
	board.unregister_entity(grid_pos)
	board.register_platform_on_water(self, grid_pos)
	print("occupied_tiles:", board.occupied_tiles)
	print("platform tiles:", board.platform_tiles)
	print("log became platform")
# if an entity gets on top of it,

func deduct_point():
	breaking_point -= 1
	if breaking_point <= 0:
		board.unregister_platform_on_water_entity(grid_pos)
		queue_free()
		print("Go on...")
		$LogBreaksAudio.play()
