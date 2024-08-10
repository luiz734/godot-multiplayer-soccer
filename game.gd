extends Node2D

@onready var spawn_pos_1 = %Pos1
@onready var spawn_pos_2 = %Pos2
@onready var puck_pos = %PuckPos
@onready var player_prefab: PackedScene = preload("res://player.tscn")
@onready var hockey_puck_prefab: PackedScene = preload("res://hockey_puck.tscn")
@onready var win_size = get_window().size
@onready var score_manager: ScoreManager = %ScoreManager

var players = []
var puck: HockeyPuck

func _ready():
    randomize()

    score_manager.score.connect(func():
        # After finished, returns the signal animation_finished bellow
        # Use a wrapper because it's not possible call a rpc function here
        animate_goal_wrapper()
    )
    score_manager.animation_finished.connect(func():
        puck.position = puck_pos.position
        puck.reset.rpc(puck_pos)
    )
    
    for pid in Globals.players:
        var new_player = player_prefab.instantiate()
        players.push_back(new_player)
        setup_player(new_player, pid)
        new_player.self_modulate = Color(randf(), randf(), randf())
        add_child(new_player)
    
    puck = hockey_puck_prefab.instantiate()
    puck.position = puck_pos.position
    add_child(puck)    
 
@rpc("authority", "call_local", "reliable") 
func setup_player(player: Node2D, player_id: int):
    player.name = str(player_id)
    if player_id == 1:
        player.position = spawn_pos_1.position
        player.modulate = Color.BLUE
    else:
        player.position = spawn_pos_2.position
        player.modulate = Color.RED

func animate_goal_wrapper():
    animate_goal.rpc()

@rpc("authority", "call_local", "reliable") 
func animate_goal():
    score_manager.animate_goal()
    players[0].position = spawn_pos_1.position
    players[1].position = spawn_pos_2.position
