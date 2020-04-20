extends TextureRect

func _physics_process(delta):
	var ch = float(get_node("/root/GlobalVars").currhealth)
	var mh = float(get_node("/root/GlobalVars").maxhealth)
	self.modulate = Color(1, 1, 1, min(abs(pow((mh - ch)/mh, 3.0)), 1))