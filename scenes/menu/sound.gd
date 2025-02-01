extends Node

@onready var bgmusic: AudioStreamPlayer = $bgmusic
var is_playing = true

func _ready():
	play_music()
	
func play_music():
	bgmusic.play()
	is_playing = true

func toggle_music():
	if is_playing:
		bgmusic.stop()
		is_playing = false
	else:
		bgmusic.play()
		is_playing = true
