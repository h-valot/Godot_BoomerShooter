@tool
extends AudioStreamPlayer3D

class_name AudioSource

@export var audio_map: AudioMap
@export var audio_key: AudioKey = preload("res://Assets/Resources/Sound/RE_AK_Sample.tres")

func _ready():
	stream = audio_map.get_audio(audio_key)
	if autoplay && not playing:
		play()
