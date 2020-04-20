extends Particles2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	emitting = false

func blast():
	emitting = true
	set_process(false)
	yield(get_tree().create_timer(0.1), "timeout")
	set_process(true)
	emitting = false

func _process(delta):
	if get_parent().currstate == "run":
		if get_parent().get_node("AnimatedSprite").frame % 3 == 0:
			emitting = true
		else:
			emitting = false
	else:
		emitting = false
