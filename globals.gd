extends Node

func _process(_delta):
    if Input.is_action_just_pressed("quit"):
        get_tree().quit(0)

var multiplayer_peer
