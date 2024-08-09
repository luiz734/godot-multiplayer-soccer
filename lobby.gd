extends MarginContainer
class_name Lobby

@onready var player_one: Label = %PlayerOne
@onready var player_two: Label = %PlayerTwo
@onready var timer: Timer = $Timer

func set_player_one(nickname: String):
    player_one.text = nickname
    timer.timeout.connect(update_waiting)
    timer.start()
    
func set_player_two(nickname: String):
    player_two.text = nickname
    timer.stop()

func update_waiting():
    if player_two.text.begins_with("waiting"):
        if len(player_two.text) < 10:
            player_two.text += "."
        else:
            player_two.text = "waiting"
        timer.start()
    if player_one.text.begins_with("waiting"):
        if len(player_one.text) < 10:
            player_one.text += "."
        else:
            player_one.text = "waiting"
        timer.start()
