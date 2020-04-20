extends Area2D

export var message = "Lorem Ipsum"

var active = false

func _ready():
	$Popup/Label.text = message

func _on_Helper1_body_entered(body):
	if body.name == "Player":
		active = true
		get_parent().tut_bit = self

func _on_Helper1_body_exited(body):
	active = false

func _process(delta):
	if active:
		$Popup.position.y = lerp($Popup.position.y, -100, 0.2)
		$Popup.modulate.a = lerp($Popup.modulate.a, 1, 0.2)
	else:
		$Popup.position.y = lerp($Popup.position.y, -80, 0.2)
		$Popup.modulate.a = lerp($Popup.modulate.a, 0, 0.2)
