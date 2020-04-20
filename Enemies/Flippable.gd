extends Node2D

func _ready():
	pass # Replace with function body.

func flip(dir):
	for child in get_children():
		if child is Sprite or child is AnimatedSprite:
			if dir == -1:
				child.flip_h = true
			else:
				child.flip_h = false
		child.position.x = dir * abs(child.position.x)