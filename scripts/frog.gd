extends CharacterBody2D

const TILE_SIZE := 16
const HALF_TILE := Vector2(TILE_SIZE / 2, TILE_SIZE / 2)
const WATER_SPLASH = preload("res://scenes/effects/water_splash.tscn")
@onready var board = get_parent()
@onready var anim = $AnimatedSprite2D
@onready var sprite = $Sprite2D

var grid_pos: Vector2i = Vector2i(6, 4)

var facing_direction: Vector2i = Vector2i.UP

var is_platform := false
var can_be_moved := false


func _ready():
	position = Vector2(grid_pos) * TILE_SIZE + HALF_TILE

	board.register_entity(self, grid_pos)


func _unhandled_input(event):
	var direction := Vector2i.ZERO

	if Input.is_action_pressed("pull"):
		board.try_pull(self, facing_direction)
	elif Input.is_action_pressed("push"):
		board.try_push(self, facing_direction)

	if event.is_action_pressed("ui_accept"):
		play_tongue()
		return

	if event.is_action_pressed("ui_right"):
		direction = Vector2i.RIGHT
	elif event.is_action_pressed("ui_left"):
		direction = Vector2i.LEFT
	elif event.is_action_pressed("ui_up"):
		direction = Vector2i.UP
	elif event.is_action_pressed("ui_down"):
		direction = Vector2i.DOWN

	if direction == Vector2i.ZERO:
		return

	facing_direction = direction

	face_direction(direction)

	if Input.is_action_pressed("face_direction"):
		return

	board.try_move(self, direction)


func play_tongue():
	anim.play("tounge")


func face_direction(direction: Vector2i):
	if direction == Vector2i.RIGHT:
		rotation = PI / 2
	elif direction == Vector2i.LEFT:
		rotation = -PI / 2
	elif direction == Vector2i.UP:
		rotation = 0
	elif direction == Vector2i.DOWN:
		rotation = PI


func move_to_grid():
	position = Vector2(grid_pos) * TILE_SIZE + HALF_TILE

func on_enter_water():
	if board.is_platform_tile_occupied(grid_pos):
		return
	spawn_splash()
	await land_on_water_animation()
	
	await get_tree().create_timer(1.6).timeout
	queue_free()
	board.on_death()

# ANIMATIONS

func land_on_water_animation():
	var tween = create_tween()
	#await get_tree().create_timer(0.2).timeout
	tween.tween_property(self, "rotation_degrees", rotation_degrees + 720, 0.6)
	tween.parallel().tween_property(self, "scale", Vector2.ZERO, 0.6)
	print("fam what happened")
	await tween.finished

func spawn_splash():
	var splash = WATER_SPLASH.instantiate()
	splash.global_position = global_position
	get_parent().add_child(splash)
