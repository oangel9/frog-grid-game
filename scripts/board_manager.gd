#class_name BoardManager
extends Node2D

const TILE_SIZE := 16

var water_layer
var occupied_tiles: Dictionary = {}
var platform_tiles: Dictionary = {}
var mosquito_count := 0 


@onready var death_panel = $CanvasLayer/DeathPanel
@onready var score_ui = $CanvasLayer/ScorePanel
@onready var mosquitos = $Mosquitos

func _ready(): 
	water_layer = $LevelCreator/Water
	death_panel.visible = false
	mosquito_count = mosquitos.get_child_count()
	score_ui.set_score(mosquito_count)
	call_deferred("check_starting_entities")

func register_entity(entity, grid_pos: Vector2i) -> void:
	occupied_tiles[grid_pos] = entity
	
func register_platform_on_water(entity, grid_pos: Vector2i) -> void:
	platform_tiles[grid_pos] = entity
	
func unregister_entity(grid_pos: Vector2i) -> void:
	occupied_tiles.erase(grid_pos)
	
func unregister_platform_on_water_entity(grid_pos: Vector2i) -> void:
	platform_tiles.erase(grid_pos)
		
func is_tile_occupied(grid_pos: Vector2i) -> bool:
	return occupied_tiles.has(grid_pos)

func is_platform_tile_occupied(grid_pos: Vector2i) -> bool:
	return platform_tiles.has(grid_pos)

func get_entity_at(grid_pos: Vector2i):
	return occupied_tiles.get(grid_pos, null)

func get_platorm_entity_at(grid_pos: Vector2i):
	return platform_tiles.get(grid_pos, null)

func move_entity(entity, new_pos: Vector2i) -> bool:

	# Something already there?
	if is_tile_occupied(new_pos):
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
	check_on_broken_log(entity.grid_pos)

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
		
			
	if object.can_be_eaten == true:
		eat_object(object)
		#score_ui.set_score(get_mosquitos_count())
		return true
	

	if object.can_be_moved == false:
		return false
	
	var object_new_pos: Vector2i = object.grid_pos - direction

	return move_entity(object, object_new_pos)


func handle_landing(entity, pos: Vector2i):

	if is_water_tile(pos):

		entity.on_enter_water()


func is_water_tile(pos: Vector2i) -> bool:
	#if water_layer == null:
		#print("ERROR: water_layer path is wrong")
		#return false

	var cell = water_layer.get_cell_tile_data(pos)
	return cell != null

# Board checks if something was on top of tile and breaks after
func ready_break_tile():
	pass

func check_starting_entities():
	for pos in occupied_tiles.keys():
		print(pos)
		var entity = occupied_tiles[pos]
		if is_water_tile(pos) and entity.has_method("on_start_water"):
			print("This log is broken and in watar")
			entity.on_start_water()
			
func check_on_broken_log(frog_old_pos: Vector2i):
	# Check if old position was equal to any of the ones of broken logs
	#if board.occupied_tiles.has(old_pos):
	var platform = platform_tiles.get(frog_old_pos, null)
	
	if platform is BrokenLog:
		platform.deduct_point()
		# if it is, break log
		
func on_death():
	get_tree().paused = true
	death_panel.visible = true
	
func eat_object(object):
	unregister_entity(object.grid_pos)
	object.queue_free()
	mosquito_count -= 1
	score_ui.set_score(mosquito_count)
	print("there are: " ,get_mosquitos_count())
	if mosquito_count == 0:
		win_condition()
		
func get_mosquitos_count() -> int:
	print(mosquitos)
	return len(mosquitos.get_children())
	
	
func win_condition() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
