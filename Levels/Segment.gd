extends Node2D

func get_begin():
	return $Begin.position

func get_end():
	return$End.position

func _ready():
	$Begin.visible = false
	$End.visible = false

func play_boss_music():
	GlobalVars.music_arr[0].fade_in()