extends Node

const LIGHT_BLUE = Color("a2f2ff")

func on_enemy_hit(body):
	body.velo = Vector2(0, 0)
	if body.get_node("Flippable"):
		body.get_node("Flippable").modulate = LIGHT_BLUE
		return
	if body.get_node("Sprites"):
		body.get_node("Sprites").modulate = LIGHT_BLUE

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
