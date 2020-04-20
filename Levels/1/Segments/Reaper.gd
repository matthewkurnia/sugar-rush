extends KinematicBody2D

const CHEST = preload("res://Misc/Chest.tscn")
const GRAV = 40
const EXPLOSION = preload("res://Guns/Explosion/ExplosionEffect.tscn")
const maxhealth = 4000
const critical = false

export var colors = [Color(0, 0, 0, 1), Color(0, 0, 0, 1)]
var MAXSPEED = 300
var camera
var state = "neutral"
var velo = Vector2()
var player
var damage = 1
var currhealth

func add_velo(value : float):
	velo.x += value * $Flippable.scale.x * MAXSPEED/300

func set_camera_target():
	camera.target = self

func is_enemy():
	return true

func set_state(value : String):
	state = value

func check_player_in_hurt_area():
	for body in $HurtArea.get_overlapping_bodies():
		if body.name == "Player":
			if !body.invincible:
				body.take_damage(damage)

func check_death(dashed = false):
	if currhealth <= 0:
		velo = move_and_slide(Vector2(), Vector2(0, -1))
		set_physics_process(false)
		$AnimationPlayer.stop(true)
		$Flippable/Body.play("default")
		$Flippable/Scythe.play("default")
		$DeathAnimTimer.start(0.2)
		for i in 13:
			$Flippable.rotation_degrees = rand_range(15, -15)
			var explosion_instance = EXPLOSION.instance()
			explosion_instance.damage = 0
			explosion_instance.get_node("Color1").modulate = colors[0]
			explosion_instance.get_node("Color2").modulate = colors[1]
			if i == 12:
				explosion_instance.scale = Vector2(1, 1)
				explosion_instance.position = self.position
			else:
				explosion_instance.scale = 0.3 * Vector2(1, 1)
				explosion_instance.position = self.position + Vector2(rand_range(80, -80), rand_range(150, -150))
			get_parent().add_child(explosion_instance)
			yield($DeathAnimTimer, "timeout")
		get_parent().get_node("Gate").set_activate(true)
		get_parent().get_node("UI/Elements/BossHealth").visible = false
		
		var chest_inst = CHEST.instance()
		chest_inst.level = 2
		chest_inst.position = self.position
		chest_inst.velo = polar2cartesian(1000, rand_range(-PI/2 + 0.1, -PI/2 - 0.1))
		get_parent().add_child(chest_inst)
		
		self.queue_free()

func take_damage(damage, dir = null, dashed = false):
	currhealth -= damage
	$HurtAnim.play("Hurt")
	camera.shake(15, 0.1, 3)
	if currhealth < 0.3 * maxhealth:
		MAXSPEED = 900
	elif currhealth < 0.6 * maxhealth:
		MAXSPEED = 600
	get_parent().get_node("UI/Elements/BossHealth").set_curr_health(currhealth)

func check_player_in_hitbox():
	for body in $Flippable/Hitbox.get_overlapping_bodies():
		if body.name == "Player":
			state = "attack"
			$AnimationPlayer.play("attack")

func can_move_to(pos):
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(global_position, pos, [self], 1)
	if result:
		return false
	return true

func hit():
	for body in $Flippable/Hitbox.get_overlapping_bodies():
		if body is KinematicBody2D and body.name == "Player":
			body.take_damage(damage)

func _ready():
	$Flippable.scale.x = -1
	camera = get_parent().get_node("Camera")
	player = get_parent().get_node("Player")
	currhealth = maxhealth
	get_parent().get_node("UI/Elements/BossHealth").set_max_health(maxhealth)
	get_parent().get_node("UI/Elements/BossHealth").set_curr_health(currhealth)

func _physics_process(delta):
	check_death()
	if state == "attack":
		velo.x = lerp(velo.x, 0, 0.1)
	elif state == "chase":
		check_player_in_hitbox()
		var ppos = player.position
		if abs(ppos.x - position.x) <= 300:
			var dir = $Flippable.scale.x
			if !can_move_to(ppos + Vector2(-dir * 300, 0)):
				dir *= -1
				$Flippable.scale.x = dir
			velo.x = lerp(velo.x, -dir * MAXSPEED, 0.1)
		else:
			var dir = sign(ppos.x - position.x)
			velo.x = lerp(velo.x, dir * MAXSPEED, 0.1)
			$Flippable.scale.x = dir
	check_player_in_hurt_area()
	velo.y += GRAV
	velo = move_and_slide(velo, Vector2(0, -1))