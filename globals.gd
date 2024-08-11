extends Node

func _process(_delta):
    if Input.is_action_just_pressed("quit"):
        get_tree().quit(0)


@rpc("any_peer", "call_local", "reliable")     
func add_player_one_score():
    for pid in players:
        if pid == 1:
            players[pid].player_score += 1

@rpc("any_peer", "call_local", "reliable")     
func add_player_two_score():
    for pid in players:
        if pid != 1:
            players[pid].player_score += 1

var players: Dictionary = {}
