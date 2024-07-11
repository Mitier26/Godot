extends Node

const HURT = preload("res://assets/sound/hurt.wav")
const JUMP = preload("res://assets/sound/jump.wav")

@onready var audio_players = $AudioPlayers


func play_sound(sound):
	for audioStreamPlayer in audio_players.get_children():
		if not audioStreamPlayer.playing:
			audioStreamPlayer.stream = sound
			audioStreamPlayer.play()
			break
