extends MarginContainer
class_name Lobby

@onready var player_one: Label = %PlayerOne
@onready var player_two: Label = %PlayerTwo

func set_player_one(nickname: String):
    player_one.text = nickname
    
func set_player_two(nickname: String):
    player_two.text = nickname

        
