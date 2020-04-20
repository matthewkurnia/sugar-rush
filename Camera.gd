extends Node2D

var player
var target
var lockpos = Vector2()
var accel = 0.05
var strength = 0
var interval = 1
var counter = 0
var currzoom = 1
var zoom = 1

func set_target_to_player():
	target = player

func set_zoom(value : float):
	zoom = value

func _ready():
	player = get_parent().get_node("Player")
	if player:
		target = get_parent().get_node("Player")
	else:
		target = get_parent()

func shake(s : float, d : float, i : int):
	strength = s
	interval = i
	if d > $Timer.time_left:
		$Timer.start(d)

func _process(delta):
	if target.has_method("get_camera_pos"):
		lockpos = target.position + target.get_camera_pos()
	else:
		lockpos = target.position
	position.x = lerp(position.x, lockpos.x, accel)
	position.y = lerp(position.y, lockpos.y, accel)
	currzoom = lerp(currzoom, zoom, 0.1)
	$Camera2D.zoom = currzoom * Vector2(1, 1)
	if counter == 0:
		if $Timer.time_left <= 0:
			strength = lerp(strength, 0, 0.5)
		position += polar2cartesian(strength, rand_range(0, 2 * PI))
	counter += 1
	counter %= interval