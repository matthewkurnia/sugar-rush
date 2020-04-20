extends RigidBody2D

const BASEPATH = "res://Misc/Debris000%s.png"

func _ready():
	$Sprite.texture = load(BASEPATH % String(randi() % 4))
	self.scale = rand_range(0.4, 0.6) * Vector2(1, 1)

