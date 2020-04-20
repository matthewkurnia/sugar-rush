extends HBoxContainer

var n = 0.0

func _ready():
	pass

func _physics_process(delta):
	if int(n) != get_node("/root/GlobalVars").coin_collected:
		$Tween.interpolate_property(self, "n", n, float(get_node("/root/GlobalVars").coin_collected), 0.6, Tween.TRANS_SINE, Tween.EASE_OUT)
		$Tween.start()
	$Number/Label.text = String(int(round(n)))