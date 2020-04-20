extends StaticBody2D

var has_player = false
var player

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if player:
		if player.global_position.y + 20 <= self.global_position.y and Input.is_action_pressed("jump"):
			player.position.y -= ($CollisionShape2D.shape.extents.y + 10)
			player.velo.y = 0
	if has_player:
		if Input.is_action_just_pressed("down"):
			collision_layer = 104
			$FallTimer.start(0.1)

func _on_player_detect_body_entered(body):
	if body.name == "Player":
		has_player = true

func _on_player_detect_body_exited(body):
	if body.name == "Player":
		has_player = false

func _on_player_overlap_body_entered(body):
	if body.name == "Player":
		player = body

func _on_player_overlap_body_exited(body):
	if body.name == "Player":
		player = null

func _on_fall_timer_timeout():
			collision_layer = 105
