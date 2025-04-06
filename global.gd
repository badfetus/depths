extends Node

var times = [float(200000), float(200000), float(200000), float(200000)]

func saveData():
	var save_game = FileAccess.open("user://depth_perception.save", FileAccess.WRITE)
	var dict = {
		"times" : times,
	}
	var json_string = JSON.stringify(dict)
	print(json_string)
	save_game.store_line(json_string)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	if not FileAccess.file_exists("user://depth_perception.save"):
		saveData()
		return # No save file

	var save_game = FileAccess.open("user://depth_perception.save", FileAccess.READ)
	var json_string = save_game.get_line()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if not parse_result == OK: #parse error
		saveData()
		return
	
	var dict : Dictionary = json.get_data()
	if(dict.has("times")):
		times = dict.get("times")
		return
	else: #savefile missing data
		saveData() 
		return
