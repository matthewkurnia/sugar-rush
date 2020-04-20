extends Control

onready var buttons = $CenterContainer/VBoxContainer.get_children()

signal affirmative

func set_overlayed(value):
	get_parent().overlayed = value

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		self.queue_free()

func _ready():
	set_overlayed(true)
	for button in buttons:
		button.owner = self
	connect("affirmative", get_parent(), "exit_run")

func _exit_tree():
	set_overlayed(false)