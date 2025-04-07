extends Control


func play_sound(sound_path, type, pitch=1.0, volume_db=0.0):
	get_node(type).stream = load(sound_path)
	get_node(type).pitch_scale = pitch
	get_node(type).volume_db = volume_db
	get_node(type).play()

#func apply_bus_volume(type, volume_db=0.0):
	#get_node(type).volume_db = volume_db

func pause_sound(type):
	get_node(type).stop()

func get_sound_duration(sound_path):
	var sound = AudioStreamPlayer.new()
	sound.stream = load(sound_path)	
	return sound.get_stream_length()

func get_sound_position(type):
	return get_node(type).get_playback_position()

func get_sound_path(type):
	return get_node(type).stream

func is_sound_playing(type):
	return get_node(type).is_playing()

func stop_sound(type):
	get_node(type).stop()
