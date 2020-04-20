extends TextureButton

const SETT = preload("res://Menu/Settings.tscn")

func _ready():
	pass # Replace with function body.

func _pressed():
	var s = SETT.instance()
	owner.add_child(s)