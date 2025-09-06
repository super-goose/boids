extends Node3D

@export var total_boids = 10
var Boid3D = preload("res://scenes/boid_3d/boid_3d.tscn")

func _ready():
	print("adding a boid")
	for i in range(total_boids):
		var boid = Boid3D.instantiate()
		var direction = Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1))
		while direction.length() == 0:
			direction = Vector3(randi_range(-1, 1), randi_range(-1, 1), randi_range(-1, 1))

		boid.set_stats(
			Vector3(randi_range(1, 3), randi_range(4, 7), randi_range(1, 3)),
			direction,
		)
		if i == 2:
			boid.is_the_one()
		$BoidContainer.add_child(boid)

func _process(delta):
	if Input.is_action_just_pressed("utility_reload"):
		get_tree().reload_current_scene()

	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

	if (Input.is_action_just_pressed("restart")):
		get_tree().reload_current_scene()

	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused
