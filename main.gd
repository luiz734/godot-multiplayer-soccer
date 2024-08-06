extends Node2D


@onready var menu_network_prefab: PackedScene = load("res://network_menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
    get_tree().change_scene_to_packed(menu_network_prefab)
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
