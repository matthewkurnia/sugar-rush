extends TextureButton

const AYSAT = preload("res://Menu/AreYouSureAboutThat.tscn")


func _ready():
	pass

func _pressed():
	var a = AYSAT.instance()
	owner.add_child(a)
