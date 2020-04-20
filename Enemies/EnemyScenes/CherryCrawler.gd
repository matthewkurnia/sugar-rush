extends Node

const BULLET = preload("res://Enemies/EnemyBullets/Red.tscn")

onready var parent = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func handle_anim(state):
	if state == "walk" or state == "chase":
		parent.get_node("Flippable/AnimatedSprite").play("walk")
	elif state == "idle":
		parent.get_node("Flippable/AnimatedSprite").play("idle")

func attack():
	parent.get_node("AnimationPlayer").play("attack")

func hit():
	var bulletinstance = BULLET.instance()
	bulletinstance.direction = 90 - parent.direction * 90 + rand_range(5, -5)
	bulletinstance.rotation_degrees = bulletinstance.direction
	bulletinstance.position = parent.position
	bulletinstance.damage = parent.damage
	parent.get_parent().add_child(bulletinstance)