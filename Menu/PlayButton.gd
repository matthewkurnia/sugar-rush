extends TextureButton

const TRANS = preload("res://UI/Transition.tscn")

func _pressed():
	var tutorial_played = Save.settings.settings.tutorial
	var t = TRANS.instance()
	owner.add_child(t)
	t.scene_exit()
	GlobalVars.reset_player_vars()
	if GlobalVars.curr_music:
		GlobalVars.curr_music.fade_out()
	yield(t.get_node("AnimationPlayer"), "animation_finished")
	if tutorial_played:
		get_tree().change_scene("res://Levels/1/Level.tscn")
	else:
		get_tree().change_scene("res://Levels/Tutorial/Level.tscn")