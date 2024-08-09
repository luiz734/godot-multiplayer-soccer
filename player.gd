extends Node2D

@export var speed = 400
var velocity:= Vector2.ZERO

func _physics_process(delta):
    var input_direction = Input.get_vector("left", "right", "up", "down")
    velocity = input_direction * speed
    position += velocity * delta
