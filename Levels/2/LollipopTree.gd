extends Node2D

func _ready():
	$AnimationPlayer.playback_speed = rand_range(0.8, 1.5)
