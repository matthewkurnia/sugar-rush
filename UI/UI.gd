extends CanvasLayer

func _ready():
	GlobalVars.ui = self

func get_transition():
	return $Elements/Transition

func take_damage():
	$Elements/Player/TakeDamage/AnimationPlayer.play("ouch")