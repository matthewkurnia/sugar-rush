extends Node2D

var damage
var camera

func _ready():
	if get_parent().get_node("Camera"):
		camera = get_parent().get_node("Camera")
		camera.shake(30 * self.scale.length(), 0.5, 3)
	var children = get_children()
	for child in children:
		if child is AnimatedSprite:
			child.play("default")
	$Smoke.emitting = true
	yield(get_tree().create_timer(0.06), "timeout")
	if damage:
		for body in $Hitbox.get_overlapping_bodies():
			if body is KinematicBody2D:
				if body.has_method("is_enemy"):
					body.velo.x += sign((body.position - self.position).x) * 2000
					body.take_damage(damage, rad2deg((body.position - self.position).angle()))
				if body.name == "Player":
					body.velo += (body.position - self.position).normalized() * 1000
					body.take_damage(1)
	yield(get_tree().create_timer(0.5), "timeout")
	$Smoke.emitting = false
	yield(get_tree().create_timer($Smoke.lifetime), "timeout")
	queue_free()