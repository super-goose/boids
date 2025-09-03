extends Node3D

var Boid3D = preload("res://scenes/boid_3d/boid_3d.tscn")

func _ready():
	print("adding a boid")
	$BoidContainer.add_child(Boid3D.instantiate())
	$BoidContainer.add_child(Boid3D.instantiate())

func _process(delta):
	if Input.is_action_just_pressed("utility_reload"):
		get_tree().reload_current_scene()

	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

	if (Input.is_action_just_pressed("restart")):
		get_tree().reload_current_scene()

	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused
