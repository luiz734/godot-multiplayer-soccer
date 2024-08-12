extends MarginContainer
class_name Lobby

@onready var player_one: Label = %PlayerOne
@onready var player_two: Label = %PlayerTwo
@onready var status: Label = %StatusLabel
@onready var player_list: VBoxContainer = %PlayerList

func set_player_one(nickname: String):
    player_one.text = nickname
    
func set_player_two(nickname: String):
    player_two.text = nickname

## This function is fully optional
## It only shows the player nicknames and a "get ready" message
func change_to_prematch():
    # return
    await get_tree().create_timer(2.0).timeout
    status.text = "GET READY!"
    player_list.hide()
    await get_tree().create_timer(1.0).timeout
