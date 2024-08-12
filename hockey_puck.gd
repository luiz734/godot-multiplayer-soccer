extends CharacterBody2D
class_name HockeyPuck


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const IMPULSE_FORCE = 2000.0
var sync_position: Vector2
var peer_id: int = 1

@onready var multiplayer_sync = $MultiplayerSynchronizer
@onready var trail: Trail = %Trail
@onready var kick_player: AudioStreamPlayer = %KickPlayer

func _ready():
    # Fix fast movement instead of teleporting on start of game (not round)
    sync_position = position

func _physics_process(delta):
    if _is_authority():
        var collision := move_and_collide(velocity * delta)
        if collision:
            velocity = velocity.bounce(collision.get_normal())
            kick_player.play()
        velocity = lerp(velocity, Vector2.ZERO, 0.01)
        sync_position = position
    else:
        position = position.lerp(sync_position, 0.5)

func _is_authority() -> bool:
    return multiplayer_sync.get_multiplayer_authority() == multiplayer.get_unique_id()

@rpc("authority", "call_local", "reliable")
func reset(pos: Vector2):
    trail.visible = false
    sync_position = pos
    position = pos  
    #position = pos
    multiplayer_sync.set_multiplayer_authority(1)
    #velocity = -Vector2(randf(), randf())
    velocity = Vector2.ZERO
    #velocity = velocity.normalized() * IMPULSE_FORCE
    
@rpc("any_peer", "call_local", "unreliable")
func apply_impulse(dir_norm: Vector2):
    kick_player.play()
    velocity = dir_norm * IMPULSE_FORCE
    trail.visible = true
    if multiplayer.is_server():
        print_debug("visible now")
    
#@rpc("authority", "call_local", "reliable")
#func force_set_position(pos: Vector2):
    #sync_position = pos
    #position = pos    
    #velocity = Vector2.ZERO

@rpc("any_peer", "call_local", "reliable")
func set_authority(id: int):
    self.peer_id = id
    multiplayer_sync.set_multiplayer_authority(peer_id)
