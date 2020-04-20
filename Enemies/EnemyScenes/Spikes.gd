extends Area2D

var player
var bodies = []

func _ready():
	pass

func _on_spikes_body_entered(body):
	if body.name == "Player":
		player = body
	else:
		bodies.append(body)

func _on_spikes_body_exited(body):
	if body.name == "Player":
		player = null
	else:
		bodies.erase(body)

func _physics_process(delta):
	if player:
		player.take_damage(1)
	for body in bodies:
		if body.has_method("is_enemy") && !body.has_method("is_boss"):
			body.take_damage(body.maxhealth)