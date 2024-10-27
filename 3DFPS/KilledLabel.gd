extends Label

var fmt = "Killed %d"
var killed = 0

func _ready():
	self.text = fmt % killed
