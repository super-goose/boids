extends Node3D

var Boid3D = preload("res://scenes/boid_3d/boid_3d.tscn")

func _ready():
	print("adding a boid")
	var boid = Boid3D.instantiate()
	$BoidContainer.add_child(boid)
