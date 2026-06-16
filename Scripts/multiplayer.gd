extends Node3D
#https://youtu.be/M0LJ9EsS_Ak?si=c8fQimf5AQu3q8qI 
var peer = ENetMultiplayerPeer.new()
@export var player_scene : PackedScene

func _on_join_pressed():
	peer.create_server(1027)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player)
	_add_player()
	
func _on_host_pressed():
	peer.create_client("127.0.0.1", 1027)
	multiplayer.multiplayer_peer = peer

func _add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)

func _exit_game(id):
	multiplayer.peer_disconnected.connect(delete_player)
	delete_player(id)

func delete_player(id):
	rpc("delete_player",id)
@rpc("any_peer","call_local")
func _delete_player(id):
	get_node(str(id)).queue_free()
