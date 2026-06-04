extends Panel

var mosquitos
@onready var board = get_parent().get_parent()
@onready var mosquito_label = $Label

func _ready():
	pass

func set_score(count: int):
	mosquito_label.text = "🦟 x " + str(count)
