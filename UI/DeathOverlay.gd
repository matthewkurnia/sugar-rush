extends Control

var messages = [
	"YOU DIED.",
	"WASTED.",
	"WHOOPSIE."
]

func _ready():
	randomize()
	messages.shuffle()
	$CenterContainer/Label.text = messages.front()

func _on_AnimationPlayer_animation_finished(anim_name):
	if GlobalVars.curr_music:
		GlobalVars.curr_music.fade_out()
	get_tree().change_scene("res://Menu/Menu.tscn")
