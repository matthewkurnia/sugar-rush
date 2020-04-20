extends "BaseEnemy.gd"

const GRAV = 40

export var walkspeed = 300.0
export var walkdistance = 500.0
export var turntime = 1.0
export var accel = 0.2

var velo = Vector2()
var direction = 1
var walktime = 0.0

func _ready():
	common_ready()
	$Flippable/EdgeDetect.position = $CollisionShape2D.shape.extents
	$Flippable/Visibility.position.x = $Flippable/Visibility/CollisionShape2D.shape.extents.x
	$Flippable/Visibility/CollisionShape2D.shape.extents.y = $CollisionShape2D.shape.extents.y

func set_state(value):
	state = value

func get_state():
	return state

func update_direction(value):
	direction = value
	$Flippable.flip(direction)

func is_on_edge():
	var bodies = $Flippable/EdgeDetect.get_overlapping_bodies()
	for body in bodies:
		if body is TileMap or body.name.begins_with("SoftPlatform"):
			return false
	return is_on_floor()

func _physics_process(delta):
	check_death()
	if !state == "attack":
		check_player_visible($Flippable/Visibility)
	check_player_in_hurt_area()
	if state == "attack":
		velo.x = lerp(velo.x, 0, accel)
	if state == "chase":
		if !check_still_visible(target):
			state = "walk"
		update_direction(sign(target.global_position.x - global_position.x))
		if is_on_edge() or is_on_wall():
			state = "idle"
			$TurnTimer.start(turntime)
			walktime = 0
		else:
			velo.x = lerp(velo.x, direction * walkspeed, accel)
		check_player_in_hitbox()
	if state == "walk":
		walktime += delta
		velo.x = lerp(velo.x, direction * walkspeed, accel)
		if is_on_edge() or walktime >= walkdistance/walkspeed or is_on_wall():
			state = "idle"
			$TurnTimer.start(turntime / 2)
			walktime = 0
	elif state == "idle":
		velo.x = lerp(velo.x, 0, accel)
	$Controller.handle_anim(state)
	velo.y += GRAV
	velo = move_and_slide(velo, Vector2(0, -1))

func turn():
	if !state == "attack":
		update_direction(-direction)
		$WalkTimer.start(turntime / 2)

func start_walk():
	if state == "chase" or state == "attack":
		return
	state = "walk"

func check_player_in_hitbox():
	var bodies = $Flippable/HitBox.get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			state = "attack"
			$Controller.attack()