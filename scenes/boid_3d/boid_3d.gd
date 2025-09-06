class_name Boid
extends CharacterBody3D

@export var speed = 14

var direction = Vector3.FORWARD
var rotation_speed = 3 * PI / 2
var target_velocity = Vector3.ZERO
var neighbors: Array[Boid] = []

func _ready():
	print('new boid!')

func _physics_process(delta):
	print('boid movin')
	# check for average direction
	var average_direction = Vector3.ZERO
	for neighbor in neighbors:
		average_direction = average_direction + neighbor.direction

	average_direction = average_direction.normalized()

	#direction = direction.rotated(Vector3.UP, rotation_speed * delta)
	#lerp_angle(0, PI, 1)
	#rotate_y(rotation_speed * delta)
	
	direction = direction.normalized()

	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.y = direction.y * speed
	target_velocity.z = direction.z * speed

		
	## Vertical Velocity
	#if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		#target_velocity.y = target_velocity.y - (fall_acceleration * delta)

	# Moving the Character
	velocity = target_velocity
	look_at(global_transform.origin + direction, Vector3.UP)
	constrain_position()
	move_and_slide()

func constrain_position():
	var box_threshold = 30
	if position.x > box_threshold:
		position.x = -box_threshold
	elif position.x < -box_threshold:
		position.x = box_threshold

	if position.y > box_threshold + 5:
		position.y = 5
	elif position.y < 5:
		position.y = box_threshold + 5

	if position.z > box_threshold:
		position.z = -box_threshold
	elif position.z < -box_threshold:
		position.z = box_threshold

func set_stats(_position: Vector3, _direction: Vector3):
	position = _position
	direction = _direction

func _on_field_of_view_body_entered(body: Boid) -> void:
	neighbors.push_back(body)


func _on_field_of_view_body_exited(body: Boid) -> void:
	var index = neighbors.find(body)
	if (index > -1):
		neighbors.remove_at(index)
