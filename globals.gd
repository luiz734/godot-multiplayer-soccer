extends Node

func _process(_delta):
    if Input.is_action_just_pressed("quit"):
        get_tree().quit(0)

var multiplayer_peer
var player1_id
var player2_id
