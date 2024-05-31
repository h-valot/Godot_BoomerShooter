extends Resource

class_name AudioMap

@export var _audio_map: Dictionary


## Return the count of sound in the map
func get_audio_count():
	return _audio_map.size()


## Return an [AudioStream] based on the name passed.
func get_audio(name: AudioKey) -> AudioStream:

	var audio: AudioStream = null

	for sound in _audio_map:
		if sound.resource_path == name.resource_path:
			audio = _audio_map[sound]
			break

	assert(audio != null, "Missing audio for: " + name.resource_path)

	return audio


## Play a sound using an AudioStreamPlayer and destroy after
func play_sound(owner: Node, audio_key: AudioKey):
	
	var audio_stream_player = AudioStreamPlayer.new()
	audio_stream_player.process_mode = Node.PROCESS_MODE_PAUSABLE
	audio_stream_player.stream = get_audio(audio_key)

	audio_stream_player.finished.connect(func(): audio_stream_player.queue_free());

	owner.get_tree().add_child(audio_stream_player)


## Play a sound using an AudioStreamPlayer3D and destroy after
func play_sound_3D(owner: Node, audio_key: AudioKey):
	
	var audio_stream_player = AudioStreamPlayer3D.new()
	audio_stream_player.process_mode = Node.PROCESS_MODE_PAUSABLE
	audio_stream_player.stream = get_audio(audio_key)

	audio_stream_player.finished.connect(func(): audio_stream_player.queue_free());

	owner.get_tree().add_child(audio_stream_player)


## Play a sound using an AudioStreamPlayer3D and destroy after
func play_sound_3D_at(owner: Node, audio_key: AudioKey, position: Vector3):
	
	var audio_stream_player = AudioStreamPlayer3D.new()
	audio_stream_player.global_position = position
	audio_stream_player.process_mode = Node.PROCESS_MODE_PAUSABLE
	audio_stream_player.stream = get_audio(audio_key)

	audio_stream_player.finished.connect(func(): audio_stream_player.queue_free());

	owner.get_tree().current_scene.add_child(audio_stream_player)
