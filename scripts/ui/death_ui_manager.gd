extends Panel

@onready var restart_button = $VBoxContainer/RestartButton
@onready var menu_button = $VBoxContainer/MenuButton

func _ready():
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func _on_menu_button_pressed() -> void:
	get_tree().paused = false
	print("game restartss")
	get_tree().change_scene_to_file("res://path/to/main_menu.tscn")
	print("soo...")


func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	print("game resets")
	get_tree().reload_current_scene()
