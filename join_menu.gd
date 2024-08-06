extends Control

var game_prefab = preload("res://game.tscn")
@onready var button_join: Button = %ButtonJoin
@onready var ip: LineEdit = %IP
@onready var port: LineEdit = %Port

var multiplayer_peer
const MIN_PORT = 1023
const MAX_PORT = 65535

func _ready():
    multiplayer_peer = ENetMultiplayerPeer.new()
    button_join.pressed.connect(func():
        
        if not ip.text.is_valid_ip_address():
            var copy = ip.text
            ip.text = "invalid IP"
            await  get_tree().create_timer(0.5).timeout
            ip.text = copy
            return
            
        if int(port.text) < MIN_PORT or int(port.text) > MAX_PORT:
            var copy = port.text
            port.text = "invalid port"
            await  get_tree().create_timer(0.5).timeout
            port.text = copy
            return
            
        ## TODO: validate ip and port
        var err = multiplayer_peer.create_client(ip.text, int(port.text))
        multiplayer.multiplayer_peer = multiplayer_peer
        multiplayer.connection_failed.connect(func():
            pass
        )
            
        multiplayer_peer.peer_connected.connect(func(id):
            print_debug("client connected")
            button_join.self_modulate = Color.YELLOW
            button_join.text = "Waiting host"
            button_join.disabled = true
        )
    )
    ip.text_changed.connect(on_ip_text_changed)
    
    var addrs = IP.get_local_addresses()
    ip.text = addrs[0]
    port.text = str(33557)
    

func on_ip_text_changed(t: String):
    var numbers_and_dots = ""
    for c in t:
        if c.is_valid_int() or c == ".":
            numbers_and_dots += c
    t = numbers_and_dots
   
    ip.text = t
    ip.caret_column = len(t)
    
@rpc("call_local", "authority")
func start_game():
    Globals.multiplayer_peer = multiplayer_peer
    get_tree().change_scene_to_packed(game_prefab)
