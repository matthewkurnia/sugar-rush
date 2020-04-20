extends Node

const BULLET = preload("res://Enemies/EnemyBullets/Red.tscn")

onready var parent = get_parent()

var target

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func attack(value):
	if $AttackTimer.time_left == 0:
		parent.get_node("Alert").play()
		target = value
		$AttackTimer.start(parent.attacktime)

func fire():
	var targetpos = target.global_position
	for i in 3:
		var bulletinstance = BULLET.instance()
		bulletinstance.direction = rad2deg((targetpos - Vector2(0, 90) - parent.global_position).angle())
		bulletinstance.rotation_degrees = bulletinstance.direction
		bulletinstance.position = parent.position + Vector2(0, 90)
		parent.get_parent().add_child(bulletinstance)
		parent.get_node("Sprites/Flash").frame = 0
		parent.get_node("Sprites/Flash").play("default")
		parent.get_node("Hit").play()
		yield(get_tree().create_timer(0.4), "timeout")

func stop_attack():
	$AttackTimer.stop()
