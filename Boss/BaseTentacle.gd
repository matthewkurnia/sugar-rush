extends Node2D

func _ready():
	$Sprite/Tip.visible = false
	$AnimationPlayer.playback_speed = rand_range(0.2, 1.2)

func get_tip():
	return $Sprite/Tip