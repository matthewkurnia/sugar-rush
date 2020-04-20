extends Node2D

export var gun_id = 1
export var bullettype = "Minty"
export var nbullets = 1
export var knockback = 0.0
export var firerate = 200
export var spread = 10.0
export var nozzlepos = Vector2(0, 0)
export var basedamage = 10.0

var direction = 1
var bullet

func _ready():
	GlobalVars.curr_gun = gun_id
	GlobalVars.c_gun_dmg = basedamage
	bullet = get_node("/root/GlobalVars").GUNMAP.bullet_type[bullettype]
	$Flash.position.y = nozzlepos.y

func knockback():
	get_parent().velo.x -= direction * knockback * 3000
	$Sprite.scale.x = 0.25 - knockback * 1
	$Sprite.scale.y = 0.25 + knockback * 1.5
	$Sprite.rotation_degrees += -3 * direction * 90 * knockback
	$Sprite.position.x += -direction * knockback * 200

func spawn_bullets():
	for i in nbullets:
		var bulletinstance = bullet.instance()
		bulletinstance.bulletvelo += 10 * rand_range(spread, -spread)
		bulletinstance.direction = -direction * 90 + 90 + rand_range(spread, -spread)
		bulletinstance.rotation_degrees = bulletinstance.direction
		bulletinstance.position = get_parent().position + polar2cartesian(nozzlepos.length(), PI/2 + direction * (-PI/2 + nozzlepos.angle()) + deg2rad(self.rotation_degrees)) + self.position + Vector2(-direction * 50, 0)
		bulletinstance.damage = basedamage * get_node("/root/GlobalVars").damagemulti
		get_parent().get_parent().add_child(bulletinstance)
	$Flash.frame = 0
	$Flash.play("flash")
	get_parent().camera.shake(150 * knockback, 0.08, 3)
	
	var sound_inst = GlobalVars.GUNMAP.sound[gun_id].instance()
	get_parent().add_child(sound_inst)

func handle_animation():
	$Sprite.scale.x = lerp($Sprite.scale.x, 0.25, 0.2)
	$Sprite.scale.y = lerp($Sprite.scale.y, 0.25, 0.2)
	$Sprite.rotation_degrees = lerp($Sprite.rotation_degrees, 0, 0.3)
	$Sprite.position.x = lerp($Sprite.position.x, 36 * direction * get_parent().get_node("AnimatedSprite").scale.x / 0.25, 0.1)

func update_direction():
	if get_parent().name == "Player":
		direction = get_parent().currdirection
	else:
		direction = 1
	if direction == -1:
		$Sprite.flip_h = true
		$Flash.flip_h = true
	else:
		$Sprite.flip_h = false
		$Flash.flip_h = false
	$Flash.position.x = nozzlepos.x * direction
	$AnimationPlayer.playback_speed = direction

func _physics_process(delta):
	update_direction()
	if Input.is_action_pressed("fire") && $Timer.time_left == 0 && get_parent().canhandleinput:
		spawn_bullets()
		knockback()
		$Timer.start(60.0 / firerate)
	handle_animation()