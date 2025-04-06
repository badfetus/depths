extends Camera3D

var mouseDelta = Vector2()
var minLookAngle : float = -90.0
var maxLookAngle : float = 90.0
var lookSensitivity : float = 200.0

var minSensitivity = 20
var maxSensitivity = 2000

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouseDelta = event.relative

func _process(delta):
	rotation_degrees.x -= mouseDelta.y * lookSensitivity * delta
	rotation_degrees.x = clamp(rotation_degrees.x, minLookAngle, maxLookAngle)
	rotation_degrees.y -= mouseDelta.x * lookSensitivity * delta
	mouseDelta = Vector2()
	
	if Input.is_action_just_pressed("sensup"): 
		lookSensitivity *= 1.25
	if Input.is_action_just_pressed("sensdown"): 
		lookSensitivity *= 0.8
	
	lookSensitivity = min(maxSensitivity, lookSensitivity)
	lookSensitivity = max(minSensitivity, lookSensitivity)
	
