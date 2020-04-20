extends Node2D

export var interaction = "interact"
export var active = false

var initial_pos

func _ready():
	initial_pos = self.position
	$Label.text = "Press E to %s." % interaction

func _process(delta):
	if active:
		self.position.y = lerp(self.position.y, initial_pos.y, 0.2)
		self.modulate.a = lerp(self.modulate.a, 1, 0.3)
	else:
		self.position.y = lerp(self.position.y, initial_pos.y + 30, 0.2)
		self.modulate.a = lerp(self.modulate.a, 0, 0.3)