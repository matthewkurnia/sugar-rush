extends Sprite

var pos
var playerpos

func _process(delta):
	pos = get_parent().get_node("CriticalSpark").get_global_position()
	playerpos = get_parent().get_parent().player.position
	position = polar2cartesian(20, (playerpos - pos).angle())