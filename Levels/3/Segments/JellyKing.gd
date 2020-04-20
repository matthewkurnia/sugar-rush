extends KinematicBody2D

const EYE_SOUND = preload("res://Levels/3/EyeShoot.tscn")
const TENT_SOUND = preload("res://Levels/3/TentacleShoot.tscn")
const EXPLOSION = preload("res://Guns/Explosion/ExplosionEffect.tscn")
const BULLET1 = preload("res://Enemies/EnemyBullets/Red.tscn")
const BULLET2 = preload("res://Enemies/EnemyBullets/Green1.tscn")
const maxhealth = 25000
const critical = false

signal death

export var colors = [Color(0, 0, 0, 1), Color(0, 0, 0, 1)]
var velo = Vector2()
var buffer_time = 5.0
var camera
var player
var damage = 1
var currhealth
var state = "intro"

func _ready():
	$AnimatedSprite.play("default")
	camera = get_parent().get_node("Camera")
	player = get_parent().get_node("Player")
	currhealth = maxhealth
	get_parent().get_node("UI/Elements/BossHealth").set_max_health(maxhealth)
	get_parent().get_node("UI/Elements/BossHealth").set_curr_health(currhealth)

func set_state(value : String):
	state = value

func is_enemy():
	return true

func is_boss():
	return true

func set_camera_target():
	camera.target = self

func get_camera_pos():
	if state == "intro":
		return Vector2(-250, -500)
	else:
		return (position + player.position) * 0.5 - position

func check_death(dashed = false):
	if currhealth <= 0:
		emit_signal("death")
		set_physics_process(false)
		$AnimationPlayer.stop(true)
		$Eye.visible = false
		$HurtArea/CollisionShape2D.disabled = true
		$ShootSlime.stop()
		$ShootEye.stop()
		$ChangeState.stop()
		$SlidingTentacle.queue_free()
		$SpikingTentacles.queue_free()
		$DeathAnimTimer.start(0.1)
		for i in 49:
			$AnimatedSprite.rotation_degrees = rand_range(8, -8)
			var explosion_instance = EXPLOSION.instance()
			explosion_instance.damage = 0
			explosion_instance.get_node("Color1").modulate = colors[0]
			explosion_instance.get_node("Color2").modulate = colors[1]
			if i == 48:
				explosion_instance.scale = 6 * Vector2(1, 1)
				explosion_instance.position = self.position
			else:
				explosion_instance.scale = 2 * Vector2(1, 1)
				explosion_instance.position = self.position + Vector2(rand_range(700, -700), rand_range(700, -700))
			get_parent().add_child(explosion_instance)
			yield($DeathAnimTimer, "timeout")
		camera.target = player
		get_parent().get_node("UI/Elements/BossHealth").visible = false
		get_parent().get_node("AnimationPlayer").play("end_game")
		self.queue_free()

func take_damage(damage, dir = null, dashed = false):
	currhealth -= damage
	$HurtAnim.play("Hurt")
	camera.shake(15, 0.1, 3)
	if currhealth <= maxhealth * 0.3:
		buffer_time = 1.0
	elif currhealth <= maxhealth * 0.6:
		buffer_time = 3.0
	get_parent().get_node("UI/Elements/BossHealth").set_curr_health(currhealth)

func check_player_in_hurt_area():
	for body in $HurtArea.get_overlapping_bodies():
		if body.name == "Player":
			if !body.invincible:
				body.take_damage(damage)

func move_done():
	state = "neutral"
	$ChangeState.start(buffer_time)

func _on_change_state_timeout():
	randomize()
	var states = ["slide", "spike", "shoot_slime", "shoot_eye"]
	states.shuffle()
	state = states.front()
	$AnimationPlayer.play(state)

func _on_shoot_slime_timeout():
	for child in $ActiveTentacles.get_children():
		var bullet_instance = BULLET2.instance()
		var dir = rad2deg((player.position - child.get_tip().get_global_position()).angle()) + rand_range(30, -30)
		connect("death", bullet_instance, "terminate")
		bullet_instance.bulletvelo = 1000
		bullet_instance.scale = 2 * Vector2(1, 1)
		bullet_instance.direction = dir
		bullet_instance.rotation_degrees = dir
		bullet_instance.position = child.get_tip().get_global_position()
		get_parent().add_child(bullet_instance)
	var t = TENT_SOUND.instance()
	t.position = position
	get_parent().add_child(t)

func _on_shoot_eye_timeout():
	var bullet_instance = BULLET1.instance()
	var dir = rad2deg((player.position - $Eye/CriticalSpark.get_global_position()).angle())
	connect("death", bullet_instance, "terminate")
	bullet_instance.bulletvelo = 1000
	bullet_instance.scale = 2 * Vector2(1, 1)
	bullet_instance.direction = dir
	bullet_instance.rotation_degrees = dir
	bullet_instance.position = $Eye/Iris.get_global_position() + Vector2(-400, -450)
	get_parent().add_child(bullet_instance)
	
	$Eye/CriticalSpark.global_position = $Eye/Iris.get_global_position() + Vector2(-400, -450)
	$Eye/CriticalSpark.speed_scale = 3
	$Eye/CriticalSpark.frame = 0
	$Eye/CriticalSpark.play()
	
	var e = EYE_SOUND.instance()
	e.position = position
	get_parent().add_child(e)

func _physics_process(delta):
	check_death()
	check_player_in_hurt_area()