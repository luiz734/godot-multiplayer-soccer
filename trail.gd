extends Line2D
class_name Trail

@export var target: Node2D

const N_POINTS = 20
const LENGTH = 400 

var points_pos: Array[Vector2] = []

func _ready():
    #assert(target)
    for i in range(N_POINTS):
        points_pos.append(Vector2.ZERO)


func _physics_process(delta):
    position = -target.global_position
    points_pos[0] = target.global_position - global_position

    for i in range(N_POINTS - 1, 0, -1):
        points_pos[i] = points_pos[i - 1]
    points = points_pos
