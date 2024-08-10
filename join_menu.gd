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
    multiplayer.connected_to_server.connect(on_connect_to_server)
    button_join.pressed.connect(on_join_pressed) 
    button_host.pressed.connect(on_host_pressed) 
    ip.text_changed.connect(_on_ip_text_changed)
    #ip.text = IP.get_local_addresses()[1]

func wait_in_lobby():
    network.hide()
    lobby.show()

func start_game():
    if multiplayer.is_server():
        enter_game.rpc()
    
@rpc("authority", "call_local", "reliable") 
func enter_game():
    hide()
    get_tree().root.add_child(game_prefab.instantiate())

func on_connect_to_server():
    # Sends info only to host
    # Host propagate to other peers (in this case, only 1 other peer_
    send_player_info.rpc_id(1, multiplayer.get_unique_id(), nickname.text)

@rpc("any_peer", "call_remote", "reliable")
func send_player_info(player_id: int, player_nickname: String):
    if not Globals.players.has(player_id):
        Globals.players[player_id] = {
            "player_id" = player_id,
            "player_nickname" = player_nickname,
            "player_score" = 0,
        }
        # Small hack. The game only has 2 players
        if player_id == 1:
            lobby.set_player_one(player_nickname)
        else:
             lobby.set_player_two(player_nickname)
            
    if multiplayer.is_server():
        for pid in Globals.players:
            send_player_info.rpc(pid, Globals.players[pid].player_nickname)
        if Globals.players.size() == 2:
            enter_game.rpc()
    

func on_peer_connected(_id):
    # For some reason, the delay is necessary or doesn't work as expected
    #await get_tree().create_timer(0.2).timeout
    #set_host_nickname.rpc_id(id, nickname.text)
    pass
    
func on_host_pressed():
    # (960, 1011)(960, 69)
    # (960, 1011)(0, 69)
    # Help debug 2 instances
    get_window().size = Vector2i(960, 1011)
    get_window().position = Vector2i(0, 69)

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
    send_player_info(multiplayer.get_unique_id(), nickname.text)
    wait_in_lobby()

func on_join_pressed():
    get_window().size = Vector2i(960, 1011)
    get_window().position = Vector2i(960, 69)

    if not ip.text.is_valid_ip_address():
        error_overlay.show_error("Invalid IP address")
        return
    var peer = ENetMultiplayerPeer.new()
    peer.create_client(ip.text, PORT)
    if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
        error_overlay.show_error("Failed to start multiplayer client.")
        return
    multiplayer.multiplayer_peer = peer
    lobby.set_player_two(nickname.text)
    wait_in_lobby()

func _on_ip_text_changed(t: String):
    var numbers_and_dots = ""
    for c in t:
        if c.is_valid_int() or c == ".":
            numbers_and_dots += c
    t = numbers_and_dots
    ip.text = t
    ip.caret_column = len(t)
