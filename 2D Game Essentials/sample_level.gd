extends Node2D

@onready var dialogue_box = $CanvasGroup/DialogueBox

func _ready():
	_on_NPC_interaction()
	
func _on_NPC_interaction():
	var dialogue = {
		"speech1" : {"speaker": "molkang", "speech":"Hello"},
		"speech2" : {"speaker" : "malkang", "speech" : "안녕"},
		"speech3" : {"speaker" : "molkang", "speech" : "이것은 정말 유용하다"}
	}
	dialogue_box.start_dialog(dialogue)
