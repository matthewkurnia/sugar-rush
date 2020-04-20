extends KinematicBody2D

const SPIRAL_SOUND = preload("res://Levels/2/Spiral.tscn")
const CHEST = preload("res://Misc/Chest.tscn")
const EXPLOSION = preload("res://Guns/Explosion/ExplosionEffect.tscn")
const BULLET1 = preload("res://Enemies/EnemyBullets/Red.tscn")
const BULLET2 = preload("res://Enemies/EnemyBullets/Green3.tscn")
const maxhealth = 13000
const critical = false

signal death

export var colors = [Color(0, 0, 0, 1), Color(0, 0, 0, 1)]
var spiral_angle = 0
var buffer_time = 7.0
var initial_pos
var MAXSPEED = 1000
var camera
var velo = Vector2()
var player
var damage = 1
var currhealth
var state = "intro"

func set_state(value : String):
	state = value

func is_enemy():
	return true

func is_boss():
	return true

func tilt():
	$AnimatedSprite.rotation_degrees = lerp($AnimatedSprite.rotation_degrees,10 * velo.x / 1000, 0.1)

func set_camera_target():
	camera.target = self

func _ready():
	initial_pos = position
	$AnimatedSprite.play("default")
	camera = get_parent().get_node("Camera")
	player = get_parent().get_node("Player")
	currhealth = maxhealth
	get_parent().get_node("UI/Elements/BossHealth").set_max_health(maxhealth)
	get_parent().get_node("UI/Elements/BossHealth").set_curr_health(currhealth)

func get_camera_pos():
	if state == "intro":
		return Vector2(0, -200)
	else:
		return (position + player.position) * 0.5 - position

func check_death(dashed = false):
	if currhealth <= 0:
		emit_signal("death")
		velo = move_and_slide(Vector2(), Vector2(0, -1))
		set_physics_process(false)
		$AnimatedSprite.stop()
		$StateTimer.stop()
		$VigourTimer.stop()
		$ChangeState.stop()
		$AnticipationTimer.stop()
		$SpiralTimer.stop()
		$AnimationPlayer.play("fade_out")
		$DeathAnimTimer.start(0.1)
		for i in 25:
			$AnimatedSprite.rotation_degrees = rand_range(8, -8)
			var explosion_instance = EXPLOSION.instance()
			explosion_instance.damage = 0
			explosion_instance.get_node("Color1").modulate = colors[0]
			explosion_instance.get_node("Color2").modulate = colors[1]
			if i == 24:
				explosion_instance.scale = 3 * Vector2(1, 1)
				explosion_instance.position = self.position
			else:
				explosion_instance.scale = Vector2(1, 1)
				explosion_instance.position = self.position + Vector2(rand_range(250, -250), rand_range(450, -450))
			get_parent().add_child(explosion_instance)
			yield($DeathAnimTimer, "timeout")
		camera.target = player
		camera.zoom = 1.0
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
	if currhealth <= maxhealth * 0.3:
		buffer_time = 3.0
		MAXSPEED = 2000
	elif currhealth <= maxhealth * 0.6:
		buffer_time = 5.0
		MAXSPEED = 1500
	get_parent().get_node("UI/Elements/BossHealth").set_curr_health(currhealth)

func check_player_in_hurt_area():
	for body in $HurtArea.get_overlapping_bodies():
		if body.name == "Player":
			if !body.invincible:
				body.take_damage(damage)

func _physics_process(delta):
	check_death()
	check_player_in_hurt_area()
	tilt()
	if !state == "intro":
		camera.zoom = lerp(camera.zoom, 2.5, 0.05)
	if state == "spiral":
		velo = Vector2(0, 0)
		position.x = lerp(position.x, initial_pos.x, 0.005)
		position.y = lerp(position.y, initial_pos.y, 0.005)
	elif state == "vigour":
		velo.x = lerp(velo.x, 0, 0.005)
		velo.y = lerp(velo.y, 0, 0.005)
	elif state == "neutral":
		var tmp = polar2cartesian(500, velo.angle() + rand_range(-PI, PI))
		velo.x = lerp(velo.x, tmp.x, 0.01)
		velo.y = lerp(velo.y, tmp.x, 0.01)
	velo = move_and_slide(velo)

func _on_spiral_timer_timeout():
	if state == "spiral":
		for i in 4:
			var bullet_instance = BULLET1.instance()
			connect("death", bullet_instance, "terminate")
			bullet_instance.bulletvelo = 900
			bullet_instance.scale = 2 * Vector2(1, 1)
			bullet_instance.position = self.position
			bullet_instance.direction = spiral_angle + i * 90
			bullet_instance.rotation_degrees = bullet_instance.direction
			get_parent().add_child(bullet_instance)
		spiral_angle += 3
		
		var s = SPIRAL_SOUND.instance()
		s.position = position
		get_parent().add_child(s)

func _on_vigour_timer_timeout():
	if state == "vigour":
		for i in 12:
			var bullet_instance = BULLET2.instance()
			connect("death", bullet_instance, "terminate")
			bullet_instance.bulletvelo = 1500
			bullet_instance.scale = 2 * Vector2(1, 1)
			bullet_instance.position = self.position + polar2cartesian(500, i * PI / 6)
			bullet_instance.direction = i * 30
			bullet_instance.rotation_degrees = bullet_instance.direction
			get_parent().add_child(bullet_instance)
		var tmp = initial_pos - position
		if tmp:
			var angle = tmp.angle() + rand_range(-0.5, 0.5)
			velo = polar2cartesian(MAXSPEED, angle)
		$Vigour.play()

func _on_change_state_timeout():
	var states = ["spiral", "vigour"]
	states.shuffle()
	state = states.front()
	$AnimationPlayer.play(state)
	$AnticipationTimer.start(1)
	yield($AnticipationTimer, "timeout")
	$VigourTimer.start()
	$SpiralTimer.start()
	$StateTimer.start(5)

func _on_state_timer_timeout():
	$AnimationPlayer.play("fade_out")
	$VigourTimer.stop()
	$SpiralTimer.stop()
	state = "neutral"
	$ChangeState.start(buffer_time)
