extends Node

const SAVE_PATH = "res://config.cfg"

var config_file = ConfigFile.new()
var settings = {
	"settings" : {
		"tutorial" : false,
		"master_volume" : 0,
		"music_volume" : 0
	}
}

func _ready():
	if !load_settings():
		save_settings()
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), settings.settings.master_volume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("MusicVol"), settings.settings.music_volume)

func save_settings():
	for section in settings.keys():
		for key in settings[section]:
			config_file.set_value(section, key, settings[section][key])
	
	config_file.save(SAVE_PATH)

func load_settings():
	var error = config_file.load(SAVE_PATH)
	if error != OK:
		print("Failed loading settings file. Error code is %s." % error)
		return false
	
	for section in settings.keys():
		for key in settings[section]:
			settings[section][key] = config_file.get_value(section, key, null)
	return true

