extends KinematicBody2D

const PICKUP_SOUND = preload("res://SFX/Misc/CoinPickup.tscn")
const SPARK = preload("res://Enemies/CriticalSpark.tscn")
const GRAV = 40

var velo = Vector2()
var target_velo = Vector2()
var player

func _ready():
	$Sprite.scale = rand_range(0.4, 0.6) * Vector2(1, 1)
	$AnimationPlayer.playback_speed = rand_range(0.5, 2)
	$Buffer.start()
	$Collect/CollisionShape2D.disabled = true

func _physics_process(delta):
	if !player:
		velo.y += GRAV
		if is_on_floor():
			velo.x = lerp(velo.x, 0, 0.2)
	else:
		velo.x = lerp(velo.x, target_velo.x, 0.05)
		velo.y = lerp(velo.y, target_velo.y, 0.05)
	velo = move_and_slide(velo, Vector2(0, -1))

func _on_timer_timeout():
	if player:
		target_velo = polar2cartesian(rand_range(600, 1200), (player.global_position - self.global_position).angle())

func _on_detect_body_entered(body):
	if body.name == "Player":
		player = body
		$Timer.start()
		_on_timer_timeout()

func _on_collect_body_entered(body):
	if player:
		if body.name == "Player":
			Collect()

func Collect():
	get_node("/root/GlobalVars").coin_collected += randi() % 2 + 2
	var spark_instance = SPARK.instance()
	get_parent().add_child(spark_instance)
	spark_instance.z_index = 20
	spark_instance.scale = 0.1 * Vector2(1, 1)
	spark_instance.rotation_degrees = 45
	spark_instance.position = self.position
	spark_instance.frame = 0
	spark_instance.play()
	
	if GlobalVars.busy_sound():
		var p = PICKUP_SOUND.instance()
		p.position = position
		get_parent().add_child(p)
	
	self.queue_free()

func _on_buffer_timeout():
	$Collect/CollisionShape2D.disabled = false
