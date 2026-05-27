extends Node2D

const TILE_SIZE := 16
const GRID_WIDTH := 50
const GRID_HEIGHT := 50

func _draw():
	for x in range(GRID_WIDTH + 1):
		draw_line(
			Vector2(x * TILE_SIZE, 0),
			Vector2(x * TILE_SIZE, GRID_HEIGHT * TILE_SIZE),
			Color(1, 1, 1, 0.15)
		)

	for y in range(GRID_HEIGHT + 1):
		draw_line(
			Vector2(0, y * TILE_SIZE),
			Vector2(GRID_WIDTH * TILE_SIZE, y * TILE_SIZE),
			Color(1, 1, 1, 0.15)
		)
