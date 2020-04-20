extends Node

const BULLET = preload("res://Enemies/EnemyBullets/Green1.tscn")

onready var parent = get_parent()
onready var SELF = load("res://Enemies/EnemyScenes/JellySlime.tscn")

var stage = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func handle_anim(state):
	if state == "walk" or state == "idle" or state == "chase":
		parent.get_node("AnimationPlayer").play("default")
		parent.get_node("Flippable/AnimatedSprite").play("default")

func attack():
	parent.get_node("AnimationPlayer").play("attack")

func hit():
	if stage == 1:
		for i in 13:
			var bulletinstance = BULLET.instance()
			bulletinstance.direction = -15 * i
			bulletinstance.rotation_degrees = bulletinstance.direction
			bulletinstance.position = parent.position
			parent.get_parent().add_child(bulletinstance)
	if stage == 2:
		for i in 7:
			var bulletinstance = BULLET.instance()
			bulletinstance.direction = -30 * i
			bulletinstance.rotation_degrees = bulletinstance.direction
			bulletinstance.position = parent.position
			parent.get_parent().add_child(bulletinstance)
	if stage == 3:
		for i in 4:
			var bulletinstance = BULLET.instance()
			bulletinstance.direction = -60 * i
			bulletinstance.rotation_degrees = bulletinstance.direction
			bulletinstance.position = parent.position + Vector2(0, -25)
			parent.get_parent().add_child(bulletinstance)

func _on_GroundedEnemy_tree_exiting():
	if stage == 3:
		return
	for i in 3:
		var selfinstance = SELF.instance()
		selfinstance.coin = int(get_parent().coin / 3)
		selfinstance.position = parent.position
		selfinstance.maxhealth = parent.maxhealth / 3
		selfinstance.scale = parent.scale * 0.5
		selfinstance.get_node("Controller").stage = stage + 1
		selfinstance.velo = polar2cartesian(1000, deg2rad(-115 + 55 * i))
		parent.get_parent().add_child(selfinstance)
