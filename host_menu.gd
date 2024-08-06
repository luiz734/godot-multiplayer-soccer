extends Control

@onready var button_host: Button = %ButtonHost
@onready var ip: LineEdit = %IP
@onready var port: LineEdit = %Port

var multiplayer_peer
const PORT = 33557

func _ready():
    multiplayer_peer = ENetMultiplayerPeer.new()
    button_host.pressed.connect(func():
        button_host.self_modulate = Color.YELLOW
        button_host.text = "Waiting"
        button_host.disabled = true
        
        multiplayer_peer.create_server(PORT)
        multiplayer.multiplayer_peer = multiplayer_peer
        multiplayer_peer.peer_connected.connect(func(id):
            button_host.self_modulate = Color.GREEN
            button_host.text = "Start Game"
            button_host.disabled = false
        )
    )
    
    var addrs = IP.get_local_addresses()
    ip.text = addrs[1]
    port.text = str(PORT)
    
    

func _process(delta):
    pass
