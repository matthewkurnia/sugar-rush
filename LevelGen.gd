extends Node2D

const BASEPATH = "res://Levels/%s/Segments/%s.tscn"

var n_arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
var add_pos = Vector2()

export var level = 1

func get_packed_scene(lvl : int, type : String):
	print(BASEPATH % [String(lvl), type])
	return load(BASEPATH % [String(lvl), type])

func add_segment(pck_scn):
	var seg_inst = pck_scn.instance()
	seg_inst.position = add_pos - seg_inst.get_begin()
	self.add_child(seg_inst)
	add_pos += (seg_inst.get_end() - seg_inst.get_begin())

func _ready():
	randomize()
	add_segment(get_packed_scene(level, "Start"))
	n_arr.shuffle()
	for item in n_arr:
		print(item)
	for i in 3:
		add_segment(get_packed_scene(level, "Basic/%s" % String(n_arr[i])))
		if i == 0:
			add_segment(get_packed_scene(level, "Chest"))
		if i == 1:
			add_segment(get_packed_scene(level, "Shop"))
	add_segment(get_packed_scene(level, "End"))