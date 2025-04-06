extends Node3D

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("Restart"): 
		var scene = load("res://" + self.name + ".tscn")
		get_tree().change_scene_to_packed(scene)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("FullScreen"):
		var mode := DisplayServer.window_get_mode()
		var is_window: bool = mode != DisplayServer.WINDOW_MODE_FULLSCREEN
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if is_window else DisplayServer.WINDOW_MODE_WINDOWED)
