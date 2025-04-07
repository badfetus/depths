extends Control

@onready var player = get_parent().get_parent()

var celebrating = false
var celebStarted = 0

func _process(_delta: float) -> void:
	var currTime = player.currTime
	
	var minute = floori(currTime / 60)
	var second = currTime - minute * 60

	$Label.text = ("%02d" % minute) + (":%05.2f" % second)
	
	var Colors = ["[color=#00FF00]", "[color=#FFFF00]", "[color=#FF0000]", "[color=#00FFFF]"]
	
	var globalTimes : String = "[right]"
	for i in Global.times.size():
		var time = float(Global.times[i])
		if(time == float(200000)):
			break
		minute = floori(time / 60)
		second = time - minute * 60
		globalTimes = globalTimes + Colors[i] + ("%02d" % minute) + (":%06.3f" % second) + "\n"
		
	$RichTextLabel.text = globalTimes
	
	if(celebrating):
		if(player.currTime - celebStarted > 3):
			celebrating = false
			$Celebrate.text = ""

func celebrate(index):
	celebStarted = player.currTime
	celebrating = true
	var Colors = ["[color=#00FF00]", "[color=#FFFF00]", "[color=#FF0000]", "[color=#00FFFF]"]
	var colorsText = ["GREEN", "YELLOW", "RED", "THE END"]
	$Celebrate.text = Colors[index] + colorsText[index] + " REACHED!"
