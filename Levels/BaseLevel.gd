extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalVars.music_arr[$LevelGen.level].fade_in()
	yield(get_tree().create_timer(1), "timeout")
	$UI/Elements/TitleCard.fade_in()
	yield(get_tree().create_timer(3), "timeout")
	$UI/Elements/TitleCard.fade_out()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
