class_name BrokenLog
extends Node2D

const TILE_SIZE := 16
const HALF_TILE := Vector2(TILE_SIZE / 2, TILE_SIZE / 2)

@onready var board = get_parent().get_parent()

var grid_pos: Vector2i

var is_platform := true
var can_be_moved := false



# if an entity gets on top of it,
