extends Sprite

const TEXTURES = [
	preload("res://Guns/Assets/Sprites/Bullets/Skittle1.png"),
	preload("res://Guns/Assets/Sprites/Bullets/Skittle2.png"),
	preload("res://Guns/Assets/Sprites/Bullets/Skittle3.png"),
	preload("res://Guns/Assets/Sprites/Bullets/Skittle4.png")
]

func _ready():
	$AnimationPlayer.playback_speed = rand_range(1, -1)
	var randomint = randi() % 4
	var spriteused = TEXTURES[randomint]
	self.texture = spriteused

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
