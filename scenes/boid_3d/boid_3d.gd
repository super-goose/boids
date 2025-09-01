extends CharacterBody3D

@export var speed = 14

var rotation_speed = 3.14
var target_velocity = Vector3.ZERO

func _ready():
	print('new boid!')
	position = Vector3(3, 6, 0)

func _physics_process(delta):
	print('boid movin')

	# We create a local variable to store the input direction.
	var direction = Vector3.FORWARD
	
	direction.normalized()
	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	## Vertical Velocity
	#if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		#target_velocity.y = target_velocity.y - (fall_acceleration * delta)

	# Moving the Character
	velocity = target_velocity
	move_and_slide()
