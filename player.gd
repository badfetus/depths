extends RigidBody3D

@onready
var camera: Camera3D = $Camera3D

var mouseDelta = Vector2()
var holdDuration = 0
var jumping = false

var playingJumpSound = false
var jumpSoundStart = -100

var reached = [false, false, false, false]

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)	
	connect("body_entered", _on_body_entered)

func _physics_process(delta: float) -> void:
	if(!jumping and playingJumpSound):
		if(currTime - jumpSoundStart > 0.1):
			playingJumpSound = false
			$JumpPlayer.stop()
		
	currTime = currTime + delta
	if(jumping):
		holdDuration += delta
	elif(holdDuration > 0):
		jump()
		holdDuration = 0
	if(position.y < -5):
		position.y = 3
		position.x = 0
		position.z = 0
		apply_central_impulse(linear_velocity * -1)
		
	handleCheats()
	
func handleCheats():
	if Input.is_action_just_pressed("Cheat"): 
			var camRot = camera.rotation
			var horizontalRotation = camRot.y
	
			var impulse = Vector3()
			impulse.y = getNormalisedAngle(camRot.x)
			impulse.y = impulse.y * 30 * 1
			impulse.x = sin(horizontalRotation) * 30 * 1 * abs(cos(getNormalisedAngle(camRot.x)))
			impulse.z = cos(horizontalRotation) * 30 * 1 * abs(cos(getNormalisedAngle(camRot.x)))
			apply_central_impulse(impulse)
	if Input.is_action_just_pressed("Cheat2"): 
		apply_central_impulse(linear_velocity * -1)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and on_floor:
		jumping = true
		$JumpPlayer.play(0.0)
		jumpSoundStart = currTime
		playingJumpSound = true
	elif event is InputEventMouseButton and !event.is_pressed():
		jumping = false

var lastJump = -100
var leeway = 0.1

func jump():
	if(currTime - lastJump < leeway):
		return
	
	lastJump = currTime
	
	var camRot = camera.rotation
	var horizontalRotation = camRot.y
	
	holdDuration = min(0.5, holdDuration)
	holdDuration = max(0.1, holdDuration)
	var impulse = Vector3()
	impulse.y = getNormalisedAngle(camRot.x)
	impulse.y = max(0.3, impulse.y) * 30 * holdDuration
	impulse.x = sin(horizontalRotation) * 30 * holdDuration * abs(cos(getNormalisedAngle(camRot.x)))
	impulse.z = cos(horizontalRotation) * 30 * holdDuration * abs(cos(getNormalisedAngle(camRot.x)))
	apply_central_impulse(impulse)

func getNormalisedAngle(angle: float) -> float:
	var normAngle = fmod(angle, (PI * 2))
	if(normAngle > PI):
		normAngle -= 2 * PI
	return normAngle

var on_floor: bool = false # now global!
var currTime = 0
var lastTimeOnFloor = -100

func _on_body_entered(body):
	if(body.name.begins_with("CP")):
		var index = int(body.name.substr(2)) - 1
		Global.updateTime(index, currTime)
		if(!reached[index]):
			$Camera3D/Control.celebrate(index)
		
func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	on_floor = false
	
	var i := 0
	while i < state.get_contact_count():
		var normal := state.get_contact_local_normal(i)
		var this_contact_on_floor = normal.dot(Vector3.UP) > 0.5

		# boolean math, will stay true if any one contact is on floor
		on_floor = on_floor or this_contact_on_floor
		i += 1
	if (on_floor):
		lastTimeOnFloor = currTime
	elif (currTime - lastTimeOnFloor < leeway):
		on_floor = true
		
	if(!on_floor):
		jumping = false
