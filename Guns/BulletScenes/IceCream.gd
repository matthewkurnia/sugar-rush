extends KinematicBody2D

const EXPLOSION = preload("res://Guns/Explosion/ExplosionEffect.tscn")

export var bulletvelo = 0
export var bulletaccel = 0
export var color1 = Color(0, 0, 0, 0)
export var color2 = Color(0, 0, 0, 0)

var velo = Vector2()
var direction = 0
var damage

func _ready():
	pass # Replace with function body.

func terminate():
	bulletvelo = 0
	bulletaccel = 0
	$CollisionShape2D.disabled = true
	$Sprite.visible = false
	var explosioninstance = EXPLOSION.instance()
	explosioninstance.position = self.position
	explosioninstance.get_node("Color1").modulate = color1
	explosioninstance.get_node("Color2").modulate = color2
	explosioninstance.damage = damage
	get_parent().add_child(explosioninstance)
	$Particles2D.emitting = false
	yield(get_tree().create_timer($Particles2D.lifetime), "timeout")
	self.queue_free()

func check_terminate():
	var bodies = $Hitbox.get_overlapping_bodies()
	for body in bodies:
		if body is StaticBody2D or body is TileMap:
			terminate()
			set_physics_process(false)
		if body is KinematicBody2D:
			if body.has_method("is_enemy"):
				terminate()
				set_physics_process(false)

func _physics_process(delta):
	check_terminate()
	bulletvelo += bulletaccel
	velo = polar2cartesian(bulletvelo, deg2rad(direction))
	move_and_slide(velo)