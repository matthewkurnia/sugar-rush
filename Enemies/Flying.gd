extends "BaseEnemy.gd"

export var speed = 100.0
export var changedirectiontime = 0.5
export var accel = 0.1
export var attacktime = 1.5

var velo = Vector2(0, 0)
var direction = 0.0

func _ready():
	common_ready()
	$HurtArea/CollisionShape2D.shape.radius = $CollisionShape2D.shape.radius * 0.8
	$HurtArea/CollisionShape2D.shape.height = $CollisionShape2D.shape.radius * 0.8
	$WallDetect/CollisionShape2D.shape.radius = $CollisionShape2D.shape.radius * 1.5
	$WallDetect/CollisionShape2D.shape.height = $CollisionShape2D.shape.height * 1.5

func _physics_process(delta):
	check_death()
	check_player_visible($Visibility)
	check_player_in_hurt_area()
	if target:
		if target.global_position.x - self.global_position.x <= 0:
			$Sprites.flip_h = true
		else:
			$Sprites.flip_h = false
		$Controller.attack(target)
		if !check_still_visible(target):
			$Controller.stop_attack()
			target = null
	if is_on_ceiling() or is_on_floor() or is_on_wall():
		change_direction()
	velo.x = lerp(velo.x, polar2cartesian(speed, deg2rad(direction)).x, accel)
	velo.y = lerp(velo.y, polar2cartesian(speed, deg2rad(direction)).y, accel)
	velo = move_and_slide(velo, Vector2(0, -1))

func change_direction():
	direction = rand_range(0, 360)
