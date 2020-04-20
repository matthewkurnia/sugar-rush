extends KinematicBody2D

const COIN_SOUND = preload("res://SFX/Enemy/CoinSound.tscn")
const SFX = preload("res://SFX/Misc/ChestOpen.tscn")
const OPENFX = preload("res://Enemies/EnemyDeath.tscn")
const DROP = preload("res://Guns/DroppedGun.tscn")
const COIN = preload("res://Misc/Coin.tscn")
const TADA = preload("res://Misc/Tada.tscn")
const GRAV = 40
const critical = false

export var level = 1
export var colors = [Color(0, 0, 0, 1), Color(0, 0, 0, 1), Color(0, 0, 0, 1), Color(0, 0, 0, 1)]
var velo = Vector2()
var opened = false

func is_enemy():
	return true

func take_damage(damage, dir = null, dashed = false):
	if opened:
		return
	randomize()
	var openfx_instance = OPENFX.instance()
	var idx = 0
	for child in openfx_instance.get_node("Debris").get_children():
		child.modulate = colors[idx]
		idx += 1
	openfx_instance.position = self.position
	openfx_instance.set_dir(-90)
	openfx_instance.set_dashed(false)
	openfx_instance.scale = 0.5 * Vector2(1, 1)
	get_parent().add_child(openfx_instance)
	
	var s = SFX.instance()
	s.position = self.position
	get_parent().add_child(s)
	var c = COIN_SOUND.instance()
	c.position = position
	get_parent().add_child(c)
	
	for i in 30:
		var coin_instance = COIN.instance()
		coin_instance.velo = Vector2(rand_range(-800, 800), rand_range(-500, -1200))
		coin_instance.position = self.position
		get_parent().add_child(coin_instance)
	
	var drop_instance = DROP.instance()
	drop_instance.gun_id = randi() % 12 + 1
	drop_instance.basedamage = GlobalVars.GUNMAP.damage[drop_instance.gun_id] * (1 + (level-1) * rand_range(0.3, 0.6))
	drop_instance.position = self.position
	drop_instance.velo.y = -600
	drop_instance.velo.x = rand_range(-100, 100)
	get_parent().add_child(drop_instance)
	
	var tada_instance = TADA.instance()
	tada_instance.position = self.position
	get_parent().add_child(tada_instance)
	
	opened = true
	
	
	self.queue_free()

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	velo.y += GRAV
	if is_on_floor():
		velo.x = lerp(velo.x, 0, 0.1)
	velo = move_and_slide(velo, Vector2(0, -1))