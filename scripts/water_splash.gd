extends Node2D

@onready var particles = $GPUParticles2D

func _ready():
	particles.emitting = true
	await particles.finished
	queue_free()
