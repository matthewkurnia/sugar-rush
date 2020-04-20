extends AudioStreamPlayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	volume_db = -80

func fade_in():
	GlobalVars.curr_music = self
	$Tween.stop(self)
	$Tween.interpolate_property(self, "volume_db", -80, -10, 0.2, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()
	play()
	GlobalVars.buffer_music = true

func fade_out():
	$Tween.stop(self)
	$Tween.interpolate_property(self, "volume_db", -10, -80, 2.0, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()
	yield(get_tree().create_timer(2.5), "timeout")
	#stop()