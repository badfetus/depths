extends Node3D

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("Restart"): 
		var scene = load("res://" + self.name + ".tscn")
		get_tree().change_scene_to_packed(scene)
