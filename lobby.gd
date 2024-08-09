extends MarginContainer
class_name Lobby

signal game_ready

@onready var player_one: Label = %PlayerOne
@onready var player_two: Label = %PlayerTwo

var count := 0

func set_player_one(nickname: String):
    player_one.text = nickname
    count += 1
    if count == 2:
        game_ready.emit()
    
func set_player_two(nickname: String):
    player_two.text = nickname
    count += 1
    if count == 2:
        game_ready.emit()
        
