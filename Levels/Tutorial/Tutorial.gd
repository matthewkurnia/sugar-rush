extends Node2D

var tut_bit

func _ready():
	$Gate.connect("change_scene", self, "scene_changed")
	MusicTutorial.fade_in()
	$Begin.visible = false
	$End.visible = false
	$Player.connect("take_damage", self, "try_again")
	$DevilLollipop2.take_damage(99)

func try_again():
	GlobalVars.currhealth = GlobalVars.maxhealth
	if tut_bit:
		$Player.position = tut_bit.position

func scene_changed():
	GlobalVars.reset_player_vars()
	Save.settings.settings.tutorial = true
	Save.save_settings()