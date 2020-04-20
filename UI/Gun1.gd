extends VBoxContainer

func set_status(value : String):
	if value == "Current Gun":
		$Status.set("custom_colors/font_color", Color("1b9ea1"))
	else:
		$Status.set("custom_colors/font_color", Color("2264ab"))
	$Status.text = value

func set_name(value : String):
	$Name.text = value

func set_dps(value : int):
	$Stats/Value/DPS.text = String(value)

func set_firerate(value : int):
	$Stats/Value/FIRERATE.text = String(value)

func set_spread(value : int):
	$Stats/Value/SPREAD.text = String(value)

func set_info(value : String):
	if value:
		$Info.text = value

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
