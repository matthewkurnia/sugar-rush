extends KinematicBody2D

const TERM_S = preload("res://SFX/GunShot/Terminate.tscn")

export var bulletvelo = 0
export var bulletaccel = 0

var velo = Vector2()
var direction = 0
var damage = 1

func _ready():
	pass # Replace with function body.

func terminate():
	set_physics_process(false)
	move_and_slide(Vector2(0, 0))
	$CollisionShape2D.disabled = true
	$Sprite.visible = false
	$TerminateSprite.visible = true
	$TerminateSprite.play("terminate")
	var t_inst = TERM_S.instance()
	t_inst.position = position
	get_parent().add_child(t_inst)
	yield($TerminateSprite, "animation_finished")
	self.queue_free()

func check_terminate():
	var bodies = $Hitbox.get_overlapping_bodies()
	for body in bodies:
		if body is KinematicBody2D:
			if body.name == "Player":
				if body.can_take_damage():
					body.take_damage(damage)
					terminate()
		elif body.has_method("is_enemy"):
			return
		elif body is StaticBody2D or body is TileMap:
			terminate()

func _physics_process(delta):
	check_terminate()
	bulletvelo += bulletaccel
	velo = polar2cartesian(bulletvelo, deg2rad(direction))
	move_and_slide(velo)