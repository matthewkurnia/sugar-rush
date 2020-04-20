extends Control

func set_max_health(value):
	$CenterContainer/Over.max_value = value
	$CenterContainer/Under.max_value = value

func set_curr_health(value):
	$CenterContainer/Over.value = value
	$Tween.interpolate_property($CenterContainer/Under, "value", $CenterContainer/Under.value, value, 0.4, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()