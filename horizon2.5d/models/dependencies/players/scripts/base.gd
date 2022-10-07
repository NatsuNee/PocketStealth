extends KinematicBody

export var speed := 7.0
export var jump_strength := 0.0
export var gravity := 50.0

var _velocity := Vector3.ZERO
var _snap_vector := Vector3.DOWN
var lookdirectionaxis = 0
var yieldtimer = false
var firstpersonview = false
var mouse_sensitivity = 0.3
var cameratype

onready var _spring_arm: SpringArm = $SpringArm
onready var _player_camera_origin = $PlayerCameraOrigin
onready var _animationplayer = $AnimationPlayer
onready var _animationtree = $AnimationTree
onready var animationState = _animationtree.get("parameters/playback")
#onready var _model: Spatial = $AstronautSkin
func changecamera():
	match cameratype:
		"ThirdPerson":
			firstpersonview = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			$UI/Weapon.hide()
			$PlayerCameraOrigin/PlayerCamera.current = true
		"FirstPerson":
			firstpersonview = true
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			$UI/Weapon.show()
			$FirstPersonHead/PlayerCameraFP.current = true
		
	
func _input(event):
	if event is InputEventMouseMotion and firstpersonview == true:
		$FirstPersonHead.rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		$FirstPersonHead/PlayerCameraFP.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity)) # Try using a seperate camera
		$FirstPersonHead/PlayerCameraFP.rotation.x = clamp($FirstPersonHead/PlayerCameraFP.rotation.x, deg2rad(-70), deg2rad(50))

func _physics_process(delta: float) -> void:
	var move_direction := Vector3.ZERO
	move_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	move_direction.z = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	move_direction = move_direction.rotated(Vector3.UP, _player_camera_origin.rotation.y).normalized()
	
	if firstpersonview == false:
		_velocity.x = move_direction.x * speed
		_velocity.z = move_direction.z * speed
		_velocity.y -= gravity * delta
	else:
		_velocity = Vector3(0,0,0)
	
	animationpicker()
		
	if move_direction != Vector3.ZERO and firstpersonview == false:
		RunAnim()
	else:
		IdleAnim()
	
	camerafunc(move_direction)
	
	var just_landed := is_on_floor() and _snap_vector == Vector3.ZERO
	var is_jumping := is_on_floor() and Input.is_action_just_pressed("jump")
	if is_jumping:
		_velocity.y = jump_strength
		_snap_vector = Vector3.ZERO
	elif just_landed:
		_snap_vector = Vector3.DOWN
		
	_velocity = move_and_slide_with_snap(_velocity, _snap_vector, Vector3.UP, true)
	
	if _velocity.length() > 0.2:
		var look_direction = Vector2(_velocity.z, _velocity.x)
	
func _process(_delta: float) -> void:
#	_player_camera_origin.translation = translation
	if Input.is_action_pressed("rotatecameraleft") and firstpersonview == false:
		$PlayerCameraOrigin.rotate_y(+0.02)
		$FirstPersonHead.rotation_degrees.y = $PlayerCameraOrigin.rotation_degrees.y
	if Input.is_action_pressed("rotatecameraright") and firstpersonview == false:
		$PlayerCameraOrigin.rotate_y(-0.02)
		$FirstPersonHead.rotation_degrees.y = $PlayerCameraOrigin.rotation_degrees.y
	if Input.is_action_pressed("aim"):
		cameratype = "FirstPerson"
		changecamera()
	else:
		cameratype = "ThirdPerson"
		changecamera()
		
func animationpicker():
	#print(Vector2(lookdirectionaxis, $PlayerCameraOrigin.rotation_degrees.y))
	if $PlayerCameraOrigin.rotation_degrees.y <= 0 and $PlayerCameraOrigin.rotation_degrees.y >= -44.999998:
		lookdirectionaxis = 1
	elif $PlayerCameraOrigin.rotation_degrees.y <= -44.999999 and $PlayerCameraOrigin.rotation_degrees.y >= -135:
		lookdirectionaxis = 2
	elif $PlayerCameraOrigin.rotation_degrees.y <= -135.1 and $PlayerCameraOrigin.rotation_degrees.y >= -180:
		lookdirectionaxis = 3
	elif $PlayerCameraOrigin.rotation_degrees.y <= 180 and $PlayerCameraOrigin.rotation_degrees.y >= 135:
		lookdirectionaxis = 3
	elif $PlayerCameraOrigin.rotation_degrees.y <= 134.999 and $PlayerCameraOrigin.rotation_degrees.y >= 45:
		lookdirectionaxis = 4
	elif $PlayerCameraOrigin.rotation_degrees.y <= 45 and $PlayerCameraOrigin.rotation_degrees.y >= 0:
		lookdirectionaxis = 1
	
	
		
func IdleAnim():
	match lookdirectionaxis:
		1:
			animationState.travel("IdleFront")
		2:
			animationState.travel("IdleRight")
		3:
			animationState.travel("IdleDown")
		4:
			animationState.travel("IdleLeft")
		
func RunAnim():
	match lookdirectionaxis:
		1:
			animationState.travel("RunFront")
		2:
			animationState.travel("RunRight")
		3:
			animationState.travel("RunDown")
		4:
			animationState.travel("RunLeft")
		
func camerafunc(move_direction):
	if move_direction != Vector3.ZERO:
		var lookdirection = move_direction.z + _player_camera_origin.rotation.x
		_animationtree.set("parameters/IdleFront/blend_position", Vector2(move_direction.x, move_direction.z))
		_animationtree.set("parameters/IdleLeft/blend_position", Vector2(move_direction.x, move_direction.z))
		_animationtree.set("parameters/IdleRight/blend_position", Vector2(move_direction.x, move_direction.z))
		_animationtree.set("parameters/IdleDown/blend_position", Vector2(move_direction.x, move_direction.z))
		_animationtree.set("parameters/RunFront/blend_position", Vector2(move_direction.x, move_direction.z))
		_animationtree.set("parameters/RunLeft/blend_position", Vector2(move_direction.x, move_direction.z))
		_animationtree.set("parameters/RunRight/blend_position", Vector2(move_direction.x, move_direction.z))
		_animationtree.set("parameters/RunDown/blend_position", Vector2(move_direction.x, move_direction.z))
	
	
