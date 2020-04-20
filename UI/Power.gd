extends HBoxContainer

const ICON = preload("res://Misc/Power.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in GlobalVars.power_collected:
		var inst = ICON.instance()
		add_child(inst)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
