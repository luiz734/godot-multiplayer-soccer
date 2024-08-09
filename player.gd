extends CharacterBody2D

@export var speed = 1000
@onready var multiplayer_sync = $MultiplayerSynchronizer

var sync_position: Vector2

func _ready():
    sync_position = position
    multiplayer_sync.set_multiplayer_authority(name.to_int())
    
func _physics_process(delta):
    if not multiplayer_sync.get_multiplayer_authority() == multiplayer.get_unique_id():
        position = position.lerp(sync_position, 0.5)
        
    else:
        var input_direction = Input.get_vector("left", "right", "up", "down")
        velocity = input_direction * speed
        var collision = move_and_collide(velocity * delta)
        if collision:
            velocity = velocity.slide(collision.get_normal())
            var collider = collision.get_collider()
            if collider.has_method("apply_impulse"):
                var push_to_dir = (collider.global_position - global_position).normalized()
                collider.apply_impulse.rpc(push_to_dir)
                #collider.apply_impulse(push_to_dir)
        #position += velocity * delta
        sync_position = position


