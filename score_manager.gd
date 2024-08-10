extends Node2D
class_name ScoreManager

signal player_one_score
signal player_two_score
signal score

@onready var player_one_goal: Area2D = %PlayerOneGoal
@onready var player_two_goal: Area2D = %PlayerTwoGoal
@onready var tween_start_pos: Node2D = %TweenPosStart
@onready var tween_middle_pos: Node2D = %TweenPosMid
@onready var tween_end_pos: Node2D = %TweenPosEnd
@onready var goal_label: Node2D = %GoalLabel

var p1_goals: int = 0
var p2_goals: int = 0

func _ready():
    player_one_goal.body_entered.connect(on_player_one_score)
    player_two_goal.body_entered.connect(on_player_two_score)
    #animate_goal()

func on_player_one_score(body):
    p1_goals += 1
    await animate_goal()
    score.emit()
    print_debug("goal p1")

func on_player_two_score(body):
    p2_goals += 1
    await animate_goal()
    score.emit()
    print_debug("goal p2")

func animate_goal():
    var tween := get_tree().create_tween()
    tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
    tween.tween_property(goal_label, "position", tween_middle_pos.position, 1.0)
    await tween.finished

    var tween2 := get_tree().create_tween()
    tween2.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
    tween2.tween_property(goal_label, "position", tween_end_pos.position, 1.0)
    await tween2.finished

    goal_label.position = tween_start_pos.position

    
func _process(delta):
    pass
