extends CharacterBody3D

const ROTATION_SPEED = 180

@export var gravity_toggle = true

const SPEED = 5.0
const JUMP_VELOCITY = 9.0
@onready var state = 'idle'
#@onready var animation_player = $Visual/AnimationPlayer
#@onready var mesh_model = $Visual/Model

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta: float) -> void:
	_update_camera(delta)

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = get_direction(delta)
	calculate_velocity(direction, delta)
	move_and_slide()

func get_direction(delta: float):
	var new_rotation = 0.0
	
	if Input.is_action_pressed("ui_left"):
		new_rotation += ROTATION_SPEED * delta
	if Input.is_action_pressed("ui_right"):
		new_rotation -= ROTATION_SPEED * delta
	if new_rotation != 0:
		rotate_y(deg_to_rad(new_rotation))

	# Handle Jump.
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	return direction

func calculate_velocity(direction: Vector3, delta: float):
	# GRAVITY
	if not is_on_floor() and gravity_toggle:
		velocity.y -= gravity * delta * 2

	if direction:
		#rotation.y = atan2(direction.x, direction.z)
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	if velocity.length() == 0:
		state = 'idle'
	elif velocity.y < 0:
		state = 'fall'
	elif velocity.y > 0:
		state = 'jump'
	elif velocity.x + velocity.z != 0:
		state = 'run'

#
#
#

var _mouse_input : bool = false
var _mouse_rotation : Vector3
var _rotation_input : float
var _tilt_input : float
var _player_rotation : Vector3
var _camera_rotation : Vector3
var camera: Camera3D

@export var TILT_LOWER_LIMIT := deg_to_rad(-90.0)
@export var TILT_UPPER_LIMIT := deg_to_rad(90.0)
@export var MOUSE_SENSITIVITY : float = 0.5 

func _ready():
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	camera = $Camera3D

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	_mouse_input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if _mouse_input :
		_rotation_input = -event.relative.x * MOUSE_SENSITIVITY
		_tilt_input = -event.relative.y * MOUSE_SENSITIVITY
		print(Vector2(_rotation_input,_tilt_input))

func _update_camera(delta):
	_mouse_rotation.x += _tilt_input * delta
	_mouse_rotation.x = clamp(_mouse_rotation.x, TILT_LOWER_LIMIT, TILT_UPPER_LIMIT)
	_mouse_rotation.y += _rotation_input * delta
	
	_player_rotation = Vector3(0.0,_mouse_rotation.y,0.0)
	_camera_rotation = Vector3(_mouse_rotation.x,0.0,0.0)
	
	camera.transform.basis = Basis.from_euler(_camera_rotation)
	camera.rotation.z = 0.0
	
	global_transform.basis = Basis.from_euler(_player_rotation)
	
	_rotation_input = 0.0
	_tilt_input = 0.0
