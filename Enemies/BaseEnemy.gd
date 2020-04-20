extends KinematicBody2D

const STEREO = preload("res://SFX/StereoAudio.tscn")
const CRIT_SOUND = preload("res://SFX/Enemy/Critical.tscn")
const COIN_SOUND = preload("res://SFX/Enemy/CoinSound.tscn")
const is_enemy = true
const EXPLODE = preload("res://Enemies/EnemyDeath.tscn")
const COIN = preload("res://Misc/Coin.tscn")

export var fxscale = 0.5
export var colors = [Color(0, 0, 0, 0), Color(0, 0, 0, 0), Color(0, 0, 0, 0), Color(0, 0, 0, 0)]
export var damage = 1
export var maxhealth = 100
export var coin = 10

var currhealth
var deathdir = -90
var critical = false
var target
var state = "walk"
var camera

func is_enemy():
	return

func common_ready():
	camera = get_parent().get_parent().get_node("Camera")
	$CriticalSpark.scale = Vector2(1, 1) * fxscale
	currhealth = maxhealth

func check_player_in_hurt_area():
	for body in $HurtArea.get_overlapping_bodies():
		if body.name == "Player":
			if !body.invincible:
				body.take_damage(damage)

func check_player_visible(Area):
	var bodies = Area.get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			var space_state = get_world_2d().direct_space_state
			var result = space_state.intersect_ray(global_position, body.global_position, [self], 1)
			if result:
				if result.collider.name == "Player":
					state = "chase"
					target = body

func check_still_visible(body):
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(global_position, body.global_position, [self], 1)
	if result:
		if result.collider.name == "Player":
			return true
	return false

func check_death(dashed = false):
	if currhealth <= 0:
		set_physics_process(false)
		var explodeinstance = EXPLODE.instance()
		var idx = 0
		for child in explodeinstance.get_node("Debris").get_children():
			child.modulate = colors[idx]
			idx += 1
		explodeinstance.scale = Vector2(1, 1) * fxscale
		explodeinstance.position = self.position
		explodeinstance.set_dir(deathdir)
		explodeinstance.set_dashed(dashed)
		get_parent().add_child(explodeinstance)
		if camera:
			camera.shake(30, 0.15, 3)
		
		if dashed:
			var ch = get_node("/root/GlobalVars").currhealth
			var dh = get_node("/root/GlobalVars").dash_health
			var mh = get_node("/root/GlobalVars").maxhealth
			get_node("/root/GlobalVars").currhealth = min(mh, ch + dh)
			coin *= 2
			
			var crit_s = CRIT_SOUND.instance()
			crit_s.position = position
			get_parent().add_child(crit_s)
		
		var death_s = $Death.stream
		var s = STEREO.instance()
		s.stream = death_s
		s.position = position
		s.volume_db = -6
		get_parent().add_child(s)
		
		for i in coin:
			var coin_instance = COIN.instance()
			coin_instance.velo = Vector2(rand_range(-500, 500), rand_range(-500, -1200))
			if dashed:
				coin_instance.velo *= 2
			coin_instance.position = self.position
			get_parent().add_child(coin_instance)
		
		var c = COIN_SOUND.instance()
		c.position = position
		get_parent().add_child(c)
		
		self.queue_free()

func take_damage(damage, dir = null, dashed = false):
	currhealth -= damage
	if float(currhealth)/float(maxhealth) <= get_node("/root/GlobalVars").criticalhealth:
		$CriticalAnim.play("critical")
		if !critical:
			$CriticalSpark.frame = 0
			$CriticalSpark.play("critical")
			
			var crit_s = CRIT_SOUND.instance()
			crit_s.position = position
			get_parent().add_child(crit_s)
		critical = true
	$HurtAnim.play("Hurt")
	if camera:
		camera.shake(15, 0.1, 3)
	if dir:
		deathdir = dir
	if dashed:
		check_death(true)
