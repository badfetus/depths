extends RigidBody3D

@onready
var camera: Camera3D = $Camera3D

var mouseDelta = Vector2()
var holdDuration = 0
var jumping = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)	

func _physics_process(delta: float) -> void:
	currTime = currTime + delta
	if(jumping):
		holdDuration += delta
	elif(holdDuration > 0):
		jump()
		holdDuration = 0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and on_floor:
		jumping = true
	elif event is InputEventMouseButton and !event.is_pressed():
		jumping = false

var lastJump = -100

func jump():
	if(currTime - lastJump < 0.05):
		return
	
	lastJump = currTime
	print("jumping")
	
	var camRot = camera.rotation
	var horizontalRotation = camRot.y

	print("horRot: " + str(horizontalRotation))
	
	holdDuration = min(0.5, holdDuration)
	holdDuration = max(0.1, holdDuration)
	var impulse = Vector3()
	impulse.y = getNormalisedAngle(camRot.x)
	impulse.y = max(0.3, impulse.y) * 30 * holdDuration
	impulse.x = -sin(horizontalRotation) * 30 * holdDuration * abs(cos(getNormalisedAngle(camRot.x)))
	impulse.z = -cos(horizontalRotation) * 30 * holdDuration * abs(cos(getNormalisedAngle(camRot.x)))
	apply_central_impulse(impulse)
	print(impulse)

func getNormalisedAngle(angle: float) -> float:
	var normAngle = fmod(angle, (PI * 2))
	if(normAngle > PI):
		normAngle -= 2 * PI
	return normAngle

var on_floor: bool = false # now global!
var currTime = 0
var lastTimeOnFloor = -100

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	var i := 0
	while i < state.get_contact_count():
		var normal := state.get_contact_local_normal(i)
		var this_contact_on_floor = normal.dot(Vector3.UP) > 0.99

		# boolean math, will stay true if any one contact is on floor
		on_floor = on_floor or this_contact_on_floor
		i += 1
	if (on_floor):
		lastTimeOnFloor = currTime
	elif (currTime - lastTimeOnFloor < 0.05):
		on_floor = true
