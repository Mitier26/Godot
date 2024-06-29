extends Control

@export var dialog_texts = {}

@onready var dialog_label = $Dialogue/Label
@onready var name_label = $SpeakeName/Label
@onready var next_button = $Dialogue/Button

var current_index = 0

func _ready():
	next_button	.connect("pressed", Callable(self, "_on_NextButton_pressed"))
	visible = false
	
func start_dialog(texts):
	dialog_texts = texts
	
	current_index = 0
	
	show_next_text()
	
func _on_NextButton_pressed():
	current_index += 1
	
	if current_index < dialog_texts.size():
		show_next_text()
	else:
		visible = false
	
func show_next_text():
	var keys = dialog_texts.keys()
	
	if keys.size() > 0:
		var key = keys[current_index]
		var value = dialog_texts[key]
		
		var speech = value.keys()
		
		if speech.size() > 0:
			var speaker_key = speech[0]
			
			var speaker_value = value[speaker_key]
			
			var speech_key = speech[1]
			
			var speech_value = value[speech_key]
			
			dialog_label.text = speech_value
			
			name_label.text =  speaker_value
	visible = true
