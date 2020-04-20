extends KinematicBody2D

const SFX = preload("res://SFX/Misc/SwapGun.tscn")

onready var gun_map = get_node("/root/GlobalVars").GUNMAP

export var gun_id = 9

var active = false
var player
var velo = Vector2()
var gun_scene
var gun_texture
var basedamage = 10.0

func _ready():
	gun_scene = gun_map.packed_scene[gun_id]
	gun_texture = gun_map.textures[gun_id]
	$Sprite.texture = gun_texture
	$PopUp.position.y -100
	$PopUp.modulate.a = 0

func swap_gun(body):
	var prev_gun = body.get_node("Gun")
	prev_gun.name = "PrevGun"
	
	var new_gun = gun_scene.instance()
	new_gun.basedamage = basedamage
	body.add_child(new_gun)
	
	self.basedamage = prev_gun.basedamage
	self.gun_id = prev_gun.gun_id
	self.global_position = body.global_position
	self.velo = Vector2(body.currdirection * 300 + rand_range(50, -50), -500)
	self._ready()
	
	prev_gun.queue_free()
	
	var s = SFX.instance()
	s.position = self.position
	get_parent().add_child(s)

func set_labels(node : Node, id : int, status : String, dmg = null):
	node.set_status(status)
	node.set_dps(int(dmg * GlobalVars.GUNMAP.nbullets[id] * GlobalVars.damagemulti * GlobalVars.GUNMAP["firerate"][id] / 60.0))
	node.set_name(GlobalVars.GUNMAP["display_name"][id])
	node.set_firerate(GlobalVars.GUNMAP["firerate"][id])
	node.set_spread(GlobalVars.GUNMAP["spread"][id])
	node.set_info(GlobalVars.GUNMAP["info"][id])

func handle_anim(is_active = false):
	if is_active:
		$PopUp.position.y = lerp($PopUp.position.y, -180, 0.1)
		$PopUp.modulate.a = lerp($PopUp.modulate.a, 1, 0.1)
	else:
		$PopUp.position.y = lerp($PopUp.position.y, -100, 0.1)
		$PopUp.modulate.a = lerp($PopUp.modulate.a, 0, 0.1)

func _physics_process(delta):
	if player:
		if player.interact_arr.front() == self:
			active = true
		else:
			active = false
		
		if active:
			var c_gun = player.get_node("Gun")
			var c_gun_id = c_gun.gun_id
			set_labels($PopUp/HBoxContainer/Gun1, c_gun_id, "Current Gun", c_gun.basedamage)
			set_labels($PopUp/HBoxContainer/Gun2, gun_id, "New Gun", basedamage)
			$PopUp/HBoxContainer.update_color()
			
			if Input.is_action_just_pressed("interact"):
				swap_gun(player)
	else:
		active = false
	handle_anim(active)
	
	if is_on_floor():
		velo.x = lerp(velo.x, 0, 0.2)
	velo.y += 40
	velo = move_and_slide(velo, Vector2(0, -1))

func _on_PlayerDetect_body_entered(body):
	if body.name == "Player":
		body.interact_arr.push_back(self)
		player = body

func _on_PlayerDetect_body_exited(body):
	if body.name == "Player":
		body.interact_arr.erase(self)
		player = null
