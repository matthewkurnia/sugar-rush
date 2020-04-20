extends Node

const BULLET = preload("res://Enemies/EnemyBullets/Green2.tscn")

onready var parent = get_parent()

var stage = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func handle_anim(state):
	pass

func attack():
	parent.get_node("AnimationPlayer").play("attack")

func hit():
	for i in 8:
		var bulletinstance = BULLET.instance()
		bulletinstance.direction = 90 - parent.direction * 90 + rand_range(20, -10)
		bulletinstance.rotation_degrees = bulletinstance.direction
		bulletinstance.position = parent.position + Vector2(parent.direction * 200, 0)
		parent.get_parent().add_child(bulletinstance)
		yield(get_tree().create_timer(0.04), "timeout")

