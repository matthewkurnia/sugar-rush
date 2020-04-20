extends Control

onready var buttons = $CenterContainer/VBoxContainer.get_children()
var overlayed = false

func _input(event):
	if visible and overlayed:
		return
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().paused = !get_tree().paused
		self.visible = get_tree().paused

func _init():
	self.visible = false

func _ready():
	for button in buttons:
		button.owner = self

func exit_run():
	get_tree().paused = false
	GlobalVars.curr_music.fade_out()
	get_tree().change_scene("res://Menu/Menu.tscn")