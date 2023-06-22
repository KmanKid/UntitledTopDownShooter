extends Node2D

@onready var bullet_manager = $BulletManager
@onready var spawner: Spawner = $Spawner

var multiplayer_peer = ENetMultiplayerPeer.new()

const PORT = 9999
var address = Globals.hostIP
var connected_peer_ids = []
var local_player_character


func _ready():
	if Globals.isHost:
		multiplayer_peer.create_server(PORT)
		multiplayer.multiplayer_peer = multiplayer_peer
	
		add_player_character(1)
	
		multiplayer_peer.peer_connected.connect(
			func(new_peer_id):
				await get_tree().create_timer(0.1).timeout
				rpc("add_newly_connected_player_character", new_peer_id)
				rpc_id(new_peer_id, "add_previously_connected_player_characters", connected_peer_ids)
				add_player_character(new_peer_id)
		)
	else:
		multiplayer_peer.create_client(address,PORT)
		multiplayer.multiplayer_peer = multiplayer_peer
	
func add_player_character(peer_id):
	connected_peer_ids.append(peer_id)
	var player_character = preload("res://actors/Player.tscn").instantiate()
	player_character.set_multiplayer_authority(peer_id)
	add_child(player_character)
	player_character.player_fired_bullet.connect(bullet_manager.handle_bullet_spawned)
	player_character.dead.connect(spawner.respawn_player)
	spawner.spawn_player(player_character)
	
@rpc
func add_newly_connected_player_character(new_peer_id):
	add_player_character(new_peer_id)
	
@rpc
func add_previously_connected_player_characters(peer_ids):
	for peer_id in peer_ids:
		add_player_character(peer_id)

