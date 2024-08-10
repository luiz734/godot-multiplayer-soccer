extends CharacterBody2D

@export var speed = 1000
@onready var multiplayer_sync = $MultiplayerSynchronizer
@onready var sprite: Sprite2D = $Sprite2D

var sync_position: Vector2

var target_pos: Vector2
var clicking := false

var blue_texture = preload("res://assets/player_blue.png")
var red_texture = preload("res://assets/player_red.png")

func _ready():
    sync_position = position
    var peer_id:int = name.to_int()
    multiplayer_sync.set_multiplayer_authority(peer_id)
    sprite.texture = blue_texture if peer_id == 1 else red_texture
    target_pos = position

func _input(event):
    if event is InputEventScreenTouch:
        if event.pressed:
            target_pos = event.position
            clicking = true
        else:
            target_pos = position
            clicking = false

func get_input():
    #var input_direction = Input.get_vector("left", "right", "up", "down")
    #velocity = input_direction * speed
    clicking = Input.is_action_pressed("click")
    if clicking:
        target_pos = get_global_mouse_position()
    else:
        target_pos = global_position
    
    position = target_pos
     

func _physics_process(delta):
    if not multiplayer_sync.get_multiplayer_authority() == multiplayer.get_unique_id():
        position = position.lerp(sync_position, 0.5)
    else:
        get_input()
        var collision = move_and_collide(velocity * delta)
        if collision:
            #velocity = velocity.slide(collision.get_normal())
            var collider = collision.get_collider()
            if collider.has_method("apply_impulse"):
                var push_to_dir = (collider.global_position - global_position).normalized()
                collider.apply_impulse.rpc(push_to_dir)
                #collider.apply_impulse(push_to_dir)
        #position += velocity * delta
        sync_position = position


