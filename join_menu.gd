extends Control

@onready var button_join: Button = %ButtonJoin
@onready var ip: LineEdit = %IP
@onready var port: LineEdit = %Port

var multiplayer_peer

func _ready():
    multiplayer_peer = ENetMultiplayerPeer.new()
    button_join.pressed.connect(func():
        
        ## TODO: validate ip and port
        var err = multiplayer_peer.create_client(ip.text, int(port.text))
        multiplayer.multiplayer_peer = multiplayer_peer
        multiplayer.connection_failed.connect(func():
            pass
        )
            
        multiplayer_peer.peer_connected.connect(func(id):
            print_debug("client connected")
            #button_host.self_modulate = Color.GREEN
            #button_host.text = "Start Game"
            #button_host.disabled = false
        )
    )
    
    var addrs = IP.get_local_addresses()
    ip.text = addrs[1]
    port.text = str(33557)
    
    

func _process(delta):
    pass
