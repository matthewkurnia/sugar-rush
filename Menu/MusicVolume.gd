extends HSlider

func _ready():
	value = Save.settings.settings.music_volume

func _on_HSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("MusicVol"), value)
	Save.settings.settings.music_volume = value
	Save.save_settings()
