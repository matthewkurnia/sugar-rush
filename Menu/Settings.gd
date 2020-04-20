extends Control

func set_overlayed(value):
	get_parent().overlayed = value

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		self.queue_free()

func _ready():
	set_overlayed(true)

func _exit_tree():
	set_overlayed(false)