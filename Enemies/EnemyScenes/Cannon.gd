extends Node2D

export var fire_time = 1.3
const BULLET = preload("res://Enemies/EnemyBullets/Red.tscn")

export var delay = 0.0
export var rot = 0.0

func _ready():
	if self.rotation_degrees > 90 and self.rotation_degrees < 270:
		$Sprite.flip_v = true
	$Sprite.rotation_degrees = rot
	yield(get_tree().create_timer(delay), "timeout")
	$Timer.start(fire_time)

func _on_timer_timeout():
	$Sound.play()
	$AnimationPlayer.play("fire")
	var bullet_instance = BULLET.instance()
	bullet_instance.position = self.position + polar2cartesian(128, self.rotation + deg2rad(rot))
	bullet_instance.direction = self.rotation_degrees + rot
	bullet_instance.rotation_degrees = bullet_instance.direction
	get_parent().add_child(bullet_instance)
