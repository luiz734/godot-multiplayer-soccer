extends Control

@onready var button_host: Button = %ButtonHost
@onready var button_join: Button = %ButtonJoin

var menu_host_prefab: PackedScene = load("res://host_menu.tscn")
var menu_join_prefab: PackedScene = load("res://join_menu.tscn")


func _ready():
    button_host.pressed.connect(func():
        get_tree().change_scene_to_packed(menu_host_prefab)
    )
    button_join.pressed.connect(func():
        get_tree().change_scene_to_packed(menu_join_prefab)
    )
