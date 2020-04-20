extends Area2D

signal change_scene

const TADA = preload("res://Misc/Tada.tscn")
const texture_arr = [
	preload("res://Misc/GateSprite/Inactive.png"),
	preload("res://Misc/GateSprite/To1.png"),
	preload("res://Misc/GateSprite/To2.png"),
	preload("res://Misc/GateSprite/To3.png")
]

export var where_to = 1
export var destination_scene = ""
export var active = true

var overlap_player = false

func _ready():
	if active:
		$Sprite.texture = texture_arr[where_to]

func change_scene():
	emit_signal("change_scene")
	if GlobalVars.curr_music:
		GlobalVars.curr_music.fade_out()
	if GlobalVars.ui.get_transition():
		GlobalVars.ui.get_transition().scene_exit()
		yield(GlobalVars.ui.get_transition().get_node("AnimationPlayer"), "animation_finished")
	get_tree().change_scene(destination_scene)

func set_activate(value : bool):
	active = value
	if value:
		$Sprite.texture = texture_arr[where_to]
		var tada_instance = TADA.instance()
		tada_instance.position = self.position
		get_parent().add_child(tada_instance)
	else:
		$Sprite.texture = texture_arr[0]

func _physics_process(delta):
	if !active:
		return
	$Interact.active = overlap_player
	if overlap_player:
		if Input.is_action_just_pressed("interact"):
			change_scene()

func _on_Gate_body_entered(body):
	if body.name == "Player":
		overlap_player = true

func _on_Gate_body_exited(body):
	if body.name == "Player":
		overlap_player = false