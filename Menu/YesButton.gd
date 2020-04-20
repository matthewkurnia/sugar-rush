extends TextureButton

func _pressed():
	owner.emit_signal("affirmative")