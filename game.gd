extends Node2D

@onready var spawn_pos_1 = %Pos1
@onready var spawn_pos_2 = %Pos2
@onready var puck_pos = %PuckPos
@onready var player_prefab: PackedScene = preload("res://player.tscn")
@onready var hockey_puck_prefab: PackedScene = preload("res://hockey_puck.tscn")
@onready var win_size = get_window().size
@onready var score_manager: ScoreManager = %ScoreManager

var players = []
var puck

func _ready():
    randomize()
    score_manager.score.connect(func():
        puck.position = puck_pos.position
        puck.reset()
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
 
 
func setup_player(player: Node2D, player_id: int):
    player.name = str(player_id)
    if player_id == 1:
        player.position = spawn_pos_1.position
        player.modulate = Color.BLUE
    else:
        player.position = spawn_pos_2.position
        player.modulate = Color.RED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
