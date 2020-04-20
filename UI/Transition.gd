extends ColorRect

func scene_exit():
	$AnimationPlayer.play_backwards("fade")

func set_visible(value):
	visible = value