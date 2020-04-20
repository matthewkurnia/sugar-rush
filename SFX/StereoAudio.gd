extends AudioStreamPlayer2D

func _ready():
	play()

func _on_Stereo_finished():
	self.queue_free()
