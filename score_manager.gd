extends Node2D
class_name ScoreManager

signal player_one_score
signal player_two_score
signal animation_finished

@onready var player_one_goal: Area2D = %PlayerOneGoal
@onready var player_two_goal: Area2D = %PlayerTwoGoal
@onready var tween_start_pos: Node2D = %TweenPosStart
@onready var tween_middle_pos: Node2D = %TweenPosMid
@onready var tween_end_pos: Node2D = %TweenPosEnd
@onready var goal_label: Node2D = %GoalLabel
@onready var player_goal: AudioStreamPlayer = %PlayerGoal
@onready var score_p1: Node2D = %ScoreP1
@onready var score_p2: Node2D = %ScoreP2


func _ready():
    if multiplayer.is_server():
        player_one_goal.body_entered.connect(on_player_one_score)
        player_two_goal.body_entered.connect(on_player_two_score)
    #animate_goal()

func on_player_one_score(body):
    Globals.add_player_two_score.rpc()
    print_debug("goal p2")
    animate_goal.rpc()

func on_player_two_score(body):
    Globals.add_player_one_score.rpc()
    print_debug("goal p1")
    animate_goal.rpc()

@rpc("authority", "call_local", "reliable") 
func animate_goal():
    player_goal.play()
    var p1_goals: int = -1
    var p2_goals: int = -1
    #if not multiplayer.is_server():
    for pid in Globals.players:
        if pid == 1:
            p1_goals = Globals.players[pid].player_score
        else:
            p2_goals = Globals.players[pid].player_score
                
    score_p1.get_node("Label").text = str(p1_goals)
    score_p2.get_node("Label").text = str(p2_goals)

    var tween := get_tree().create_tween()
    tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
    tween.tween_property(goal_label, "position", tween_middle_pos.position, 1.0)
    await tween.finished

    var tween2 := get_tree().create_tween()
    tween2.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
    tween2.tween_property(goal_label, "position", tween_end_pos.position, 1.0)
    await tween2.finished

    goal_label.position = tween_start_pos.position
    await show_score_animation()
    animation_finished.emit()
    
    
func show_score_animation():
    score_p1.visible = true
    score_p2.visible = true
    score_p1.scale = Vector2.ZERO
    score_p2.scale = Vector2.ZERO
    # Grow animation
    var tween := get_tree().create_tween()
    tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
    tween.tween_method(func(t):
        score_p1.scale = t
        score_p2.scale = t, 
        Vector2.ZERO, Vector2.ONE, 2.0
    )
    await tween.finished
    # Shrink animation
    var tween1 := get_tree().create_tween()
    tween1.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
    tween1.tween_method(func(t):
        score_p1.scale = t
        score_p2.scale = t, 
        Vector2.ONE, Vector2.ZERO, 1.0
    )
    await tween1.finished    
    score_p1.visible = false
    score_p2.visible = false
