extends Control

export var title = "Insert Title Here"
export var subtitle = "INSERT SUBTITLE HERE"

func _ready():
	$CenterContainer/VBoxContainer/Sub.text = subtitle
	$CenterContainer/VBoxContainer/Title.text = title

func fade_in():
	$AnimationPlayer.play("fade")
	$AudioStreamPlayer.play()

func fade_out():
	$AnimationPlayer.play_backwards("fade")