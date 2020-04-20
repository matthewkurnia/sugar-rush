extends Node2D

export var gun_id = 1
export var bullettype = "Minty"
export var nbullets = 1
export var knockback = 0.0
export var chargetime = 0.8
export var spread = 10.0
export var nozzlepos = Vector2(0, 0)
export var basedamage = 50.0

var direction
var bullet
var charging = false

func _ready():
	GlobalVars.curr_gun = gun_id
	GlobalVars.c_gun_dmg = basedamage
	bullet = get_node("/root/GlobalVars").GUNMAP.bullet_type[bullettype]
	$Flash.position.y = nozzlepos.y

func type():
	return min(3, int(4 - $Timer.time_left / chargetime))

func knockback():
	get_parent().velo.x -= direction * knockback * 3000
	$Sprite.scale.x = 0.25 - knockback * 1 * type()
	$Sprite.scale.y = 0.25 + knockback * 1.5 * type()
	$Sprite.rotation_degrees += -3 * direction * 90 * knockback * type()
	$Sprite.position.x += -direction * knockback * 200 * type()

func spawn_bullets():
	for i in nbullets:
		var bulletinstance = bullet.instance()
		bulletinstance.set_type(type())
		bulletinstance.bulletvelo += 10 * rand_range(spread, -spread)
		bulletinstance.direction = -direction * 90 + 90 + rand_range(spread, -spread)
		bulletinstance.rotation_degrees = bulletinstance.direction
		bulletinstance.position = get_parent().position + polar2cartesian(nozzlepos.length(), PI/2 + direction * (-PI/2 + nozzlepos.angle()) + deg2rad(self.rotation_degrees)) + self.position + Vector2(-direction * 50, 0)
		bulletinstance.damage = basedamage * get_node("/root/GlobalVars").damagemulti
		get_parent().get_parent().add_child(bulletinstance)
	$Flash.scale = Vector2(0.25, 0.25) + int(4 - $Timer.time_left / chargetime) * Vector2(0.1, 0.1)
	$Flash.frame = 0
	$Flash.play("flash")
	get_parent().camera.shake(200 * knockback * type(), 0.08, 3)
	
	var sound_inst = GlobalVars.GUNMAP.sound[gun_id].instance()
	get_parent().add_child(sound_inst)

func handle_animation():
	$Sprite.scale.x = lerp($Sprite.scale.x, 0.25, 0.2)
	$Sprite.scale.y = lerp($Sprite.scale.y, 0.25, 0.2)
	$Sprite.rotation_degrees = lerp($Sprite.rotation_degrees, 0, 0.3)
	$Sprite.position.x = lerp($Sprite.position.x, 36 * direction * get_parent().get_node("AnimatedSprite").scale.x / 0.25, 0.1)
	$Sprite.position.y = lerp($Sprite.position.y, 0, 0.5)
	$"1".position.x = lerp($"1".position.x, 36 * direction * get_parent().get_node("AnimatedSprite").scale.x / 0.25, 0.1)
	$"2".position.x = lerp($"2".position.x, 36 * direction * get_parent().get_node("AnimatedSprite").scale.x / 0.25, 0.1)
	$"3".position.x = lerp($"3".position.x, 36 * direction * get_parent().get_node("AnimatedSprite").scale.x / 0.25, 0.1)
	
	
	if charging:
		$Sprite.position += 2 * Vector2(rand_range(-1, 1), rand_range(-1, 1))
		if $Timer.time_left < 3 * chargetime:
			$"1".visible = true
			$"1".play("default")
		if $Timer.time_left < 2 * chargetime:
			$"2".visible = true
			$"2".play("default")
		if $Timer.time_left < 1 * chargetime:
			$"3".visible = true
			$"3".play("default")
	else:
		$"1".stop()
		$"1".visible = false
		$"2".stop()
		$"2".visible = false
		$"3".stop()
		$"3".visible = false

func update_direction():
	if get_parent().name == "Player":
		direction = get_parent().currdirection
	else:
		direction = 1
	if direction == -1:
		$Sprite.flip_h = true
		$Flash.flip_h = true
		$"1".flip_h = true
		$"2".flip_h = true
		$"3".flip_h = true
	else:
		$Sprite.flip_h = false
		$Flash.flip_h = false
		$"1".flip_h = false
		$"2".flip_h = false
		$"3".flip_h = false
	$Flash.position.x = nozzlepos.x * direction
	$AnimationPlayer.playback_speed = direction

func _physics_process(delta):
	update_direction()
	if Input.is_action_just_released("fire") and charging:
		$Buffer.start(chargetime)
		spawn_bullets()
		knockback()
		$Timer.stop()
		$Charge.stop()
		charging = false
	if Input.is_action_just_pressed("fire") && $Buffer.is_stopped() && get_parent().canhandleinput:
		charging = true
		$Timer.start(3 * chargetime)
		$Charge.play()
	handle_animation()