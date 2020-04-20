extends Node2D

var flip_h = false

func _ready():
	for child in get_children():
		child.play("default")

func _process(delta):
	if flip_h:
		self.scale.x = -1
	else:
		self.scale.x = 1