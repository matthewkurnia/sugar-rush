extends CenterContainer

func add():
	$Sprites/HeartFilled.visible = true
	$Sprites/Fill.frame = 0
	$Sprites/Fill.play("default")

func remove():
	$Sprites/HeartFilled.visible = false
	$Sprites/Empty.frame = 0
	$Sprites/Empty.play("default")

func _ready():
	$Sprites/Fill.frame = 6
	$Sprites/Empty.frame = 8

func critical():
	$AnimationPlayer.play("critical")

func stop_critical():
	$AnimationPlayer.stop(true)
	$Sprites/HeartFilled.scale = 0.5 * Vector2(1, 1)
	$Sprites/HeartFilled.modulate = Color(1, 1, 1, 1)