extends Node

const BULLET = preload("res://Enemies/EnemyBullets/Green3.tscn")

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
	for i in 4:
		for j in 4:
			var bulletinstance = BULLET.instance()
			bulletinstance.direction = i * 45 + j * 90
			bulletinstance.rotation_degrees = bulletinstance.direction
			bulletinstance.position = parent.position
			parent.get_parent().add_child(bulletinstance)
		parent.get_node("Hit").play()
		yield(get_tree().create_timer(0.2), "timeout")

func stop_attack():
	$AttackTimer.stop()