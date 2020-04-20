extends HBoxContainer

const GREEN = Color("26c435")
const RED = Color("c42640")

onready var x = $Gun1/Stats/Value
onready var y = $Gun2/Stats/Value

func update_color():
	if int(x.get_node("DPS").text) > int(y.get_node("DPS").text):
		x.get_node("DPS").set("custom_colors/font_color", GREEN)
		y.get_node("DPS").set("custom_colors/font_color", RED)
	elif int(x.get_node("DPS").text) < int(y.get_node("DPS").text):
		x.get_node("DPS").set("custom_colors/font_color", RED)
		y.get_node("DPS").set("custom_colors/font_color", GREEN)
	else:
		x.get_node("DPS").set("custom_colors/font_color", Color.black)
		y.get_node("DPS").set("custom_colors/font_color", Color.black)
	
	if int(x.get_node("FIRERATE").text) > int(y.get_node("FIRERATE").text):
		x.get_node("FIRERATE").set("custom_colors/font_color", GREEN)
		y.get_node("FIRERATE").set("custom_colors/font_color", RED)
	elif int(x.get_node("FIRERATE").text) < int(y.get_node("FIRERATE").text):
		x.get_node("FIRERATE").set("custom_colors/font_color", RED)
		y.get_node("FIRERATE").set("custom_colors/font_color", GREEN)
	else:
		x.get_node("FIRERATE").set("custom_colors/font_color", Color.black)
		y.get_node("FIRERATE").set("custom_colors/font_color", Color.black)
	
	if int(x.get_node("SPREAD").text) > int(y.get_node("SPREAD").text):
		x.get_node("SPREAD").set("custom_colors/font_color", RED)
		y.get_node("SPREAD").set("custom_colors/font_color", GREEN)
	elif int(x.get_node("SPREAD").text) < int(y.get_node("SPREAD").text):
		x.get_node("SPREAD").set("custom_colors/font_color", GREEN)
		y.get_node("SPREAD").set("custom_colors/font_color", RED)
	else:
		x.get_node("SPREAD").set("custom_colors/font_color", Color.black)
		y.get_node("SPREAD").set("custom_colors/font_color", Color.black)
	

