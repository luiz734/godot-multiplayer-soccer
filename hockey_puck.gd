extends CharacterBody2D
class_name HockeyPuck


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const IMPULSE_FORCE = 2000.0
var sync_position: Vector2
@onready var multiplayer_sync = $MultiplayerSynchronizer

func _ready():
    multiplayer_sync.set_multiplayer_authority(1)
    velocity = -Vector2(randf(), randf())
    velocity = velocity.normalized() * IMPULSE_FORCE

func _physics_process(delta):
    if not multiplayer_sync.get_multiplayer_authority() == multiplayer.get_unique_id():
        position = position.lerp(sync_position, 0.5)
    else:
        var collision := move_and_collide(velocity * delta)
        if collision:
            velocity = velocity.bounce(collision.get_normal())
        velocity = lerp(velocity, Vector2.ZERO, 0.01)
        sync_position = position

@rpc("any_peer", "call_local", "unreliable")
func apply_impulse(dir_norm: Vector2):
    velocity = dir_norm * IMPULSE_FORCE
