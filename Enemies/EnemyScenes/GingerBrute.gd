extends Node

onready var parent = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func handle_anim(state):
	if state == "walk" or state == "chase":
		parent.get_node("Flippable/AnimatedSprite").play("walk")
	if state == "idle":
	 	parent.get_node("Flippable/AnimatedSprite").play("idle")

func attack():
	parent.get_node("AnimationPlayer").play("attack")

func hit():
	parent.camera.shake(7, 0.8, 3)
	for body in parent.get_node("Flippable/HitBox").get_overlapping_bodies():
		if body is KinematicBody2D and body.name == "Player":
			body.take_damage(parent.damage)