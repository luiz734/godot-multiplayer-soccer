extends Node2D

# Spawn locations
@onready var spawn_pos_1: Node2D = %Pos1
@onready var spawn_pos_2: Node2D = %Pos2
@onready var spawn_pos_puck: Node2D = %PuckPos
# Prefabs
@onready var player_prefab: PackedScene = preload("res://player.tscn")
@onready var hockey_puck_prefab: PackedScene = preload("res://hockey_puck.tscn")

@onready var win_size = get_window().size
@onready var score_manager: ScoreManager = %ScoreManager
@onready var whistle_player: AudioStreamPlayer = %WhistlePlayer

var players = []
var puck: HockeyPuck

func _ready():
    randomize()

    if multiplayer.is_server():
        score_manager.animation_finished.connect(func():
            puck.reset.rpc(spawn_pos_puck.position)
            whistle_player.play()
        )
    for pid in Globals.players:
        var new_player = player_prefab.instantiate()
        players.push_back(new_player)
        reset_player_position(new_player, pid)
        add_child(new_player)
    
    puck = hockey_puck_prefab.instantiate()
    puck.position = spawn_pos_puck.position
    add_child(puck)    
 
@rpc("authority", "call_local", "reliable") 
func reset_player_position(player: Node2D, player_id: int):
    player.name = str(player_id)
    if player_id == 1:
        player.position = spawn_pos_1.position
    else:
        player.position = spawn_pos_2.position

