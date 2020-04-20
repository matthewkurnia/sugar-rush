extends HBoxContainer

const HEART = preload("res://UI/Heart.tscn")

var displayed_health = 0
var n_heart
var heart_filled = []
var heart_empty = []

func _ready():
	n_heart = get_node("/root/GlobalVars").maxhealth
	for i in get_node("/root/GlobalVars").maxhealth:
		var heart_instance = HEART.instance()
		heart_instance.get_node("Sprites/HeartFilled").visible = true
		add_child(heart_instance)
		heart_filled.push_back(heart_instance)
		displayed_health += 1

func add_heart():
	heart_filled.back().stop_critical()
	heart_filled.push_back(heart_empty.front())
	heart_empty.front().add()
	heart_empty.pop_front()
	displayed_health += 1
	change_heart()

func remove_heart():
	heart_empty.push_front(heart_filled.back())
	heart_filled.back().remove()
	heart_filled.pop_back()
	displayed_health -= 1
	if heart_filled.size() == 1:
		heart_filled.back().critical()
	change_heart()

func change_heart():
	if displayed_health > get_node("/root/GlobalVars").currhealth:
		if heart_filled:
			remove_heart()
	elif displayed_health < get_node("/root/GlobalVars").currhealth:
		if heart_empty:
			add_heart()
	else:
		return

func _physics_process(delta):
	
	change_heart()
	