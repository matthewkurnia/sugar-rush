extends Control

const SAVE_PATH = "res://config.cfg"

var overlayed

onready var buttons = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer.get_children()

func _ready():
	get_tree().paused = false
	for button in buttons:
		button.owner = self
	MusicMenu.fade_in()