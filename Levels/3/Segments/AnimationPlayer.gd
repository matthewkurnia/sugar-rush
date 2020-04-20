extends AnimationPlayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func end_game():
	GlobalVars.curr_music.fade_out()
	get_tree().change_scene("res://UI/Endgame.tscn")