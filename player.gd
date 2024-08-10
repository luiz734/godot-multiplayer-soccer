extends CharacterBody2D

@export var speed = 1000

var sync_position: Vector2
var target_pos: Vector2
var _clicking := false
var _half_field: float
var _half_sprite: float
const EXTRA_ROOM = 50.0
const BLUE_TEXTURE = preload("res://assets/player_blue.png")
const RED_TEXTURE = preload("res://assets/player_red.png")
@onready var multiplayer_sync = $MultiplayerSynchronizer
@onready var sprite: Sprite2D = $Sprite2D

func _ready():
    _half_field = 1920.0 / 2.0
    _half_sprite = sprite.get_rect().size.y / 2.0
    sync_position = position
    var peer_id:int = name.to_int()
    multiplayer_sync.set_multiplayer_authority(peer_id)
    sprite.texture = BLUE_TEXTURE if peer_id == 1 else RED_TEXTURE
    target_pos = position

func _input(event):
    if event is InputEventScreenTouch:
        if event.pressed:
            target_pos = event.position
            _clicking = true
        else:
            target_pos = position
            _clicking = false

func get_input():
    _clicking = Input.is_action_pressed("click")
    if _clicking:
        target_pos = get_global_mouse_position()
    else:
        target_pos = global_position
    
    position = target_pos
    if is_host():
        position.y = clamp(position.y, 0.0, _half_field - _half_sprite + EXTRA_ROOM)
    else:
        position.y = clamp(position.y, _half_field + _half_sprite - EXTRA_ROOM, _half_field * 3.0)

func is_host():
    return name == "1"
     

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
                # collider.apply_impulse.rpc(push_to_dir)
                collider.set_authority.rpc(name.to_int())
                collider.apply_impulse(push_to_dir)
        #position += velocity * delta
        sync_position = position


