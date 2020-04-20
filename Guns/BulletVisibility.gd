extends VisibilityNotifier2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_bullet_visibility_screen_exited():
	$Timer.start(4)
	yield($Timer, "timeout")
	get_parent().queue_free()
