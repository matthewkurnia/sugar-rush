extends HSlider

func _ready():
	value = Save.settings.settings.master_volume

func _on_HSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
	Save.settings.settings.master_volume = value
	Save.save_settings()
