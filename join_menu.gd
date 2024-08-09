extends Control

var game_prefab = preload("res://game.tscn")
@onready var button_join: Button = %ButtonJoin
@onready var button_host: Button = %ButtonHost
@onready var ip: LineEdit = %IP
@onready var nickname: LineEdit = %Nickname
@onready var lobby: Lobby = %Lobby
@onready var network = %Network


@onready var error_overlay: ErrorOverlay = %ErrorOverlay

const PORT = 55667

func _ready():
    #get_tree().paused = true
    button_join.pressed.connect(on_join_pressed) 
    button_host.pressed.connect(on_host_pressed) 
    lobby.game_ready.connect(start_game)
    ip.text_changed.connect(on_ip_text_changed)
    ip.text = IP.get_local_addresses()[1]

func wait_in_lobby():
    network.hide()
    lobby.show()

func start_game():
    if multiplayer.is_server():
        enter_game.rpc()
    
@rpc("authority", "call_local", "reliable") 
func enter_game():
    hide()

func on_peer_connected(id):
    # For some reason, the delay is necessary or doesn't work as expected
    await get_tree().create_timer(0.2).timeout
    set_host_nickname.rpc_id(id, nickname.text)
    
func on_host_pressed():
  
    if not ip.text.is_valid_ip_address():
        error_overlay.show_error("Invalid IP address")
        return
    var peer = ENetMultiplayerPeer.new()
    peer.create_server(PORT)
    if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
        error_overlay.show_error("Failed to start multiplayer server")
        return
    peer.peer_connected.connect(on_peer_connected)

    multiplayer.multiplayer_peer = peer
    lobby.set_player_one(nickname.text)
    wait_in_lobby()

func on_join_pressed():
    if not ip.text.is_valid_ip_address():
        error_overlay.show_error("Invalid IP address")
        return
    var peer = ENetMultiplayerPeer.new()
    peer.create_client(ip.text, PORT)
    if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
        error_overlay.show_error("Failed to start multiplayer client.")
        return
    print_debug(peer.get_unique_id())
    multiplayer.multiplayer_peer = peer
    lobby.set_player_two(nickname.text)
    wait_in_lobby()


@rpc("authority", "call_remote", "reliable")
func set_host_nickname(nick):
    lobby.set_player_one(nick)
    set_player_two_nickname.rpc(nickname.text)

@rpc("any_peer", "call_remote", "reliable")
func set_player_two_nickname(nick):
    # For some reason, the delay is necessary or doesn't work as expected
    await get_tree().create_timer(0.2).timeout
    lobby.set_player_two(nick)

func on_ip_text_changed(t: String):
    var numbers_and_dots = ""
    for c in t:
        if c.is_valid_int() or c == ".":
            numbers_and_dots += c
    t = numbers_and_dots
    ip.text = t
    ip.caret_column = len(t)
