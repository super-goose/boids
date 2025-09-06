extends Node3D

var Boid3D = preload("res://scenes/boid_3d/boid_3d.tscn")

func _ready():
	print("adding a boid")
	for i in range(10):
		var boid = Boid3D.instantiate()
		var direction = Vector3(randi_range(-1, 1), randi_range(0, 1), randi_range(-1, 1))
		while direction.length() == 0:
			direction = Vector3(randi_range(-1, 1), randi_range(0, 1), randi_range(-1, 1))

		boid.set_stats(
			Vector3(randi_range(1, 3), randi_range(4, 7), randi_range(1, 3)),
			direction,
		)
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
