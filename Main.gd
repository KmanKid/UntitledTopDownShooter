extends Node2D

@onready var bullet_manager = $BulletManager
@onready var player: Player = $Player
@onready var button_join: Button = $Join
@onready var button_create: Button = $Create

var multiplayer_peer = ENetMultiplayerPeer.new()

const PORT = 9999
const ADDRESS = "localhost"
var connected_peer_ids = []
var local_player_character


func _ready():
	if Globals.isHost:
		button_create.visible = false
		button_join.visible = false
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
		button_join.visible = false
		button_create.visible = false
		multiplayer_peer.create_client(ADDRESS,PORT)
		multiplayer.multiplayer_peer = multiplayer_peer

func _on_create_pressed():
	button_create.visible = false
	button_join.visible = false
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

func _on_join_pressed():
	button_join.visible = false
	button_create.visible = false
	multiplayer_peer.create_client(ADDRESS,PORT)
	multiplayer.multiplayer_peer = multiplayer_peer
	
func add_player_character(peer_id):
	connected_peer_ids.append(peer_id)
	var player_character = preload("res://actors/Player.tscn").instantiate()
	player_character.set_multiplayer_authority(peer_id)
	add_child(player_character)
	if peer_id == multiplayer.get_unique_id():
		local_player_character = player_character
	player_character.player_fired_bullet.connect(bullet_manager.handle_bullet_spawned)
	
@rpc
func add_newly_connected_player_character(new_peer_id):
	add_player_character(new_peer_id)
	
@rpc
func add_previously_connected_player_characters(peer_ids):
	for peer_id in peer_ids:
		add_player_character(peer_id)

