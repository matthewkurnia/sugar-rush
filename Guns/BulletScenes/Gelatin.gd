extends KinematicBody2D

const BASEPATH = "res://Guns/Assets/Sprites/Bullets/Gelatin%s.png"
const EXPLOSION = preload("res://Guns/Explosion/ExplosionEffect.tscn")
const colors = ["21dbe8", "5f50ff", "f800ff", "d80071"]

export var bulletvelo = 0
export var bulletaccel = 0

var velo = Vector2()
var direction = 0
var damage
var type

func set_type(value):
	type = value
	var texturetype = load(BASEPATH % String(value))
	$Sprite.texture = texturetype

func _ready():
	pass # Replace with function body.

func terminate():
	bulletvelo = 0
	bulletaccel = 0
	$CollisionShape2D.disabled = true
	$Sprite.visible = false
	var explosioninstance = EXPLOSION.instance()
	explosioninstance.position = self.position
	explosioninstance.get_node("Color1").modulate = Color(colors[type - 1])
	explosioninstance.get_node("Color2").modulate = Color(colors[type])
	explosioninstance.scale = Vector2(0.25, 0.25) + type * Vector2(0.16, 0.16)
	explosioninstance.damage = damage * (1 + 2 * max(0, type-1))
	get_parent().add_child(explosioninstance)
	self.queue_free()

func check_terminate():
	var bodies = $Hitbox.get_overlapping_bodies()
	for body in bodies:
		if body is StaticBody2D or body is TileMap:
			terminate()
		if body is KinematicBody2D:
			if body.has_method("is_enemy"):
				terminate()

func _physics_process(delta):
	check_terminate()
	bulletvelo += bulletaccel
	velo = polar2cartesian(bulletvelo, deg2rad(direction))
	move_and_slide(velo)