extends KinematicBody2D

const CAMERA = preload("res://Camera.tscn")
const DEATH = preload("res://Guns/Explosion/ExplosionEffect.tscn")
const D_OVERLAY = preload("res://UI/DeathOverlay.tscn")

signal take_damage

export var grav = 30
export var fallmultiplier = 2
export var maxfallvelo = 1000
export var jumpvelo = 900
export var lowjumpmultiplier = 3
export var jumpgraceperiod = 0.1
export var jumpbuffer = 0.1
export var walljumpxmultiplier = 2.0
export var walljumpgraceperiod = 0.2
export var wallfallmultiplier = 0.3
export var maxvelo = 600
export var accel = 50
export var deccel = 0.2
export var itime = 3
export var dashduration = 0.2
export var dashspeed = 3000
export var basecamerapos = Vector2(300, -150)

var camerapos = Vector2()
var camera
var icounter = 0
var invincible = false
var currstate
var prevstate
var canhandleinput = true
var jumpsleft = 0
var gravity = true
var velo = Vector2()
var currdirection = 1
var dashjumpbuffer = false
var interact_arr = []

func set_handle_input(value : bool):
	canhandleinput = value

func _ready():
	var g_inst = GlobalVars.GUNMAP.packed_scene[GlobalVars.curr_gun].instance()
	g_inst.basedamage = GlobalVars.c_gun_dmg
	self.add_child(g_inst)
	camerapos = basecamerapos
	if get_parent().get_node("Camera"):
		camera = get_parent().get_node("Camera")
	velo = Vector2(1, 1)

func get_camera_pos():
	return camerapos

func take_damage(damage):
	if !can_take_damage():
		return
	GlobalVars.ui.take_damage()
	camera.shake(30, 0.3, 3)
	get_node("/root/GlobalVars").currhealth -= damage
	$Sound/Hurt.play()
	invincible = true
	emit_signal("take_damage")
	check_death()

func stretch_sprite():
	if currstate == "jump":
		$AnimatedSprite/AnimationPlayer.stop(true)
		$AnimatedSprite.scale.x = 0.25 - abs(pow(velo.y, 2) * 0.15 / pow(maxfallvelo, 2))
		$AnimatedSprite.scale.y = 0.25 + abs(pow(velo.y, 2) * 0.15 / pow(maxfallvelo, 2))
	elif currstate == "fall":
		$AnimatedSprite.scale.x = 0.25 - abs(pow(velo.y, 2) * 0.05 / pow(maxfallvelo, 2))
		$AnimatedSprite.scale.y = 0.25 + abs(pow(velo.y, 2) * 0.02 / pow(maxfallvelo, 2))
	else:
		$AnimatedSprite.scale.x = 0.25
		$AnimatedSprite.scale.y = 0.25

func rotate_sprite():
	if currstate == "fall":
		$AnimatedSprite.rotation_degrees = lerp($AnimatedSprite.rotation_degrees, -20 * velo.x / maxvelo, 0.1)
		$Face.rotation_degrees = lerp($AnimatedSprite.rotation_degrees, -20 * velo.x / maxvelo, 0.1)
	elif currstate == "jump":
		$AnimatedSprite.rotation_degrees = 20 * velo.x / maxvelo
		$Face.rotation_degrees = 20 * velo.x / maxvelo
	else: 
		$AnimatedSprite.rotation_degrees = 0
		$Face.rotation_degrees = 0

func is_falling():
	if !is_on_floor() && velo.y > 0:
		return true
	return false

func on_wall():
	var bodies = $WallJumpHitbox.get_overlapping_bodies()
	for body in bodies:
		if body.name == "Wall":
			return true
	return false

func update_state():
	if currstate == "dash":
		return
	prevstate = currstate
	if !is_on_floor():
		if on_wall():
			currstate = "onwall"
		elif velo.y < 0:
			currstate = "jump"
		else:
			currstate = "fall"
	else:
		if (velo.x > 50 or velo.x < -50) && (Input.is_action_pressed("left") or Input.is_action_pressed("right")):
			currstate = "run"
		else:
			currstate = "idle"

func update_direction(value):
	currdirection = value
	$WallJumpHitbox.position.x = abs($WallJumpHitbox.position.x) * currdirection
	if currdirection == -1:
		$AnimatedSprite.flip_h = true
		$Face.flip_h = true
	else:
		$AnimatedSprite.flip_h = false
		$Face.flip_h = false

func handle_anim():
	if prevstate == "fall" and is_on_floor():
		$AnimatedSprite/AnimationPlayer.play("land")
		$AnimatedSprite.play("idle")
		$Dust.blast()
	if currstate == "idle":
		if !$AnimatedSprite/AnimationPlayer.current_animation == "land":
			$AnimatedSprite/AnimationPlayer.play("idle")
		$AnimatedSprite.play("idle")
	else:
		if !$AnimatedSprite/AnimationPlayer.current_animation == "land":
			$AnimatedSprite/AnimationPlayer.stop(true)
		$AnimatedSprite.play(currstate)
	if Input.is_action_pressed("fire"):
		$Face.play("angry")
	else:
		$Face.play(currstate)
	if currstate == "run":
		$Face/AnimationPlayer.play("run")
	else:
		$Face/AnimationPlayer.play("default")

func handle_input(value):
	if !value:
		return
	if Input.is_action_just_pressed("dash") and $DashCooldown.time_left == 0:
		$DashCooldown.start()
		$Sound/Dash.play()
		if currdirection == -1:
			$DashSprite.flip_h = true
		else:
			$DashSprite.flip_h = false
		$DashSprite.frame = 0
		$DashSprite.play("dash")
		camera.shake(8, dashduration, 3)
		$DashTimer.start(dashduration)
		currstate = "dash"
		return
	if Input.is_action_pressed("left") && Input.is_action_pressed("right"):
		velo.x = lerp(velo.x, 0, deccel)
	elif Input.is_action_pressed("right"):
		update_direction(1)
		velo.x = min(velo.x + accel, maxvelo)
	elif Input.is_action_pressed("left"):
		update_direction(-1)
		velo.x = max(velo.x - accel, -maxvelo)
	else:
		velo.x = lerp(velo.x, 0, deccel)
	if Input.is_action_just_pressed("jump"):
		if jumpsleft > 0:
			if on_wall() && !is_on_floor():
				velo.x += -currdirection * maxvelo * walljumpxmultiplier
			elif $WallJumpGracePeriodTimer.time_left > 0:
				velo.x += currdirection * maxvelo * walljumpxmultiplier
			elif !is_on_floor() && $JumpGracePeriodTimer.time_left == 0:
				jumpsleft -= 1
			jump()
		else:
			$JumpBufferTimer.start(jumpbuffer)

func jump():
	$Sound/Jump.play()
	$Dust.blast()
	velo.y = -jumpvelo
	jumpsleft -= 1

func handle_gravity(value):
	if !value:
		return
	if velo.y > 0:
		if on_wall():
			velo.y = min(velo.y + grav * fallmultiplier, maxfallvelo * wallfallmultiplier)
		else:
			velo.y = min(velo.y + grav * fallmultiplier, maxfallvelo)
	elif !Input.is_action_pressed("jump"):
		velo.y += lowjumpmultiplier * grav
	else:
		velo.y += grav

func inv_dash():
	return currstate == "dash" or $DashBuffer.time_left > 0

func can_take_damage():
	return !(inv_dash() or invincible)

func on_dash_timeout():
	velo.x = 0
	gravity = true
	canhandleinput = true
	currstate = "fall"
	if dashjumpbuffer and jumpsleft > 0:
		jump()
	dashjumpbuffer = false

func check_death():
	if !visible:
		return
	if GlobalVars.currhealth <= 0:
		move_and_slide(Vector2(0, 0), Vector2(0, -1))
		canhandleinput = false
		visible = false
		var d_inst = DEATH.instance()
		d_inst.position = self.position
		get_parent().add_child(d_inst)
		GlobalVars.ui.add_child(D_OVERLAY.instance())

func _physics_process(delta):
	if currstate == "run":
		if !$Sound/Run.playing:
			$Sound/Run.play()
	else:
		$Sound/Run.stop()
	maxvelo = GlobalVars.maxvelo
	if currdirection == 1:
		camerapos.x = min(basecamerapos.x, camerapos.x + 8)
	if currdirection == -1:
		camerapos.x = max(-basecamerapos.x, camerapos.x - 8)
	if currstate == "dash":
		for body in $DashHitbox.get_overlapping_bodies():
			if body is KinematicBody2D:
				if body.has_method("is_enemy"):
					if body.critical:
						$DashCooldown.stop()
						body.take_damage(body.maxhealth, 90 - currdirection * 90, true)
		if Input.is_action_just_pressed("jump"):
			dashjumpbuffer = true
		$DashBuffer.start(0.33)
		gravity = false
		canhandleinput = false
		velo.x = currdirection * dashspeed
		velo.y = 0
	if invincible:
		$InvincibleAnim.play("invincible")
		icounter += delta
		if icounter >= itime:
			icounter = 0
			$InvincibleAnim.stop(true)
			self.modulate = Color.white
			invincible = false
	if is_on_floor():
		$JumpGracePeriodTimer.start(jumpgraceperiod)
		jumpsleft = 2
		if $JumpBufferTimer.time_left > 0:
			$JumpBufferTimer.stop()
			$Dust.blast()
			velo.y = -jumpvelo
			jumpsleft -= 1
	if on_wall():
		$WallJumpGracePeriodTimer.start(walljumpgraceperiod)
		jumpsleft = 2
	handle_input(canhandleinput)
	handle_gravity(gravity)
	update_state()
	rotate_sprite()
	stretch_sprite()
	handle_anim()
	velo = move_and_slide(velo, Vector2(0, -1))
