extends Node

const BULLET = preload("res://Enemies/EnemyBullets/Red.tscn")

onready var parent = get_parent()

var target

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func attack(value):
	if $AttackTimer.time_left == 0:
		target = value
		$AttackTimer.start(parent.attacktime)

func fire():
	parent.get_node("Alert").play()
	pass
#	var bulletinstance = BULLET.instance()
#	bulletinstance.direction = rad2deg((target.position - parent.position).angle())
#	bulletinstance.rotation_degrees = bulletinstance.direction
#	bulletinstance.position = parent.position
#	parent.get_parent().add_child(bulletinstance)
#	parent.velo += polar2cartesian(500, deg2rad(bulletinstance.direction + 180))

func stop_attack():
	$AttackTimer.stop()