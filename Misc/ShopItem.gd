extends Node2D

const CASH_SOUND = preload("res://SFX/Misc/CashRegister.tscn")

export var type = 1
export var color = Color(0, 0, 0, 1)

var player
var scale_multi = 0.7
var active = false

func _ready():
	$Sprite.texture = GlobalVars.SHOPMAP.texture[type]
	$Price/Label.text = String(GlobalVars.SHOPMAP.price[type] * get_parent().level)
	$Popup/VBoxContainer/Info.text = GlobalVars.SHOPMAP.info[type]
	$Popup/VBoxContainer/Name.text = GlobalVars.SHOPMAP.name[type]

func purchase():
	if GlobalVars.coin_collected < GlobalVars.SHOPMAP.price[type] * get_parent().level:
		$NotEnough/AnimationPlayer.play("default")
		var err = GlobalVars.ERROR_SOUND.instance()
		err.position = position
		get_parent().add_child(err)
		return
	if GlobalVars.get(GlobalVars.SHOPMAP.method[type]).call_func():
		GlobalVars.coin_collected -= GlobalVars.SHOPMAP.price[type] * get_parent().level
		set_physics_process(false)
		
		var c = CASH_SOUND.instance()
		c.position = position
		get_parent().add_child(c)
		
		$AnimationPlayer.play("purchased")
		$BigCoin.emitting = true
		$SmallCoin.emitting = true
		yield(get_tree().create_timer(0.1), "timeout")
		$BigCoin.emitting = false
		$SmallCoin.emitting = false
		yield(get_tree().create_timer(1), "timeout")
		
		self.queue_free()
	else:
		$NoNeed/AnimationPlayer.play("default")

func handle_anim(is_active):
	if is_active:
		scale_multi = lerp(scale_multi, 0.8, 0.2)
		$Popup.position.y = lerp($Popup.position.y, -30, 0.2)
		$Popup.modulate.a = lerp($Popup.modulate.a, 1, 0.2)
	else:
		scale_multi = lerp(scale_multi, 0.7, 0.2)
		$Popup.position.y = lerp($Popup.position.y, 0, 0.2)
		$Popup.modulate.a = lerp($Popup.modulate.a, 0, 0.2)
	$Sprite.scale = scale_multi * Vector2(1, 1)

func _physics_process(delta):
	if player:
		if player.interact_arr.front() == self:
			active = true
		else:
			active = false
		
		if active:
			if Input.is_action_just_pressed("interact"):
				purchase()
	else:
		active = false
	handle_anim(active)

func _on_detect_body_entered(body):
	if body.name == "Player":
		body.interact_arr.push_back(self)
		player = body

func _on_detect_body_exited(body):
	if body.name == "Player":
		body.interact_arr.erase(self)
		player = null
