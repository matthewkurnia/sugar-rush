extends Node2D

export var color1 = Color(0, 0, 0, 1)
export var color2 = Color(0, 0, 0, 1)

func set_dashed(value):
	$Dash1.visible = value
	$Dash2.visible = value

func _ready():
	$Dash1.modulate = color1
	$Dash2.modulate = color2
	$White.play("default")
	$Dash1.play("default")
	$Dash2.play("default")
	for child in $Debris.get_children():
		child.speed_scale = 2
		child.emitting = true
	yield(get_tree().create_timer(0.1), "timeout")
	for child in $Debris.get_children():
		child.emitting = false
	yield(get_tree().create_timer($Debris/Debris1.lifetime), "timeout")
	queue_free()

func set_dir(value):
	for child in $Debris.get_children():
		child.rotation_degrees = value