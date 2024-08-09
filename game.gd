extends Node2D

@onready var player1 = %Player1
@onready var player2 = %Player2

@onready var win_size = get_window().size
# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.
    #print(multiplayer.multiplayer_peer)
    player1.self_modulate = Color(randf(), randf(), randf())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if not is_multiplayer_authority():
        return
    var mouse_pos = get_global_mouse_position()
    if mouse_pos.x > win_size.x or mouse_pos.x < 0 or mouse_pos.y > win_size.y or mouse_pos.y < 0:
        return
    player2.position = mouse_pos
