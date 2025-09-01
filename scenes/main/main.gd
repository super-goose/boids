extends Node2D

var Boid = load("res://scenes/boid/boid.tscn")

func _ready():
	var b = Boid.instantiate()
	b.position = Vector2(20, 20)
	b.rotation = 1
	
	add_child(b)
