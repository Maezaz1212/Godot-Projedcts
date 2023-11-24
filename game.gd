extends Node3D

var player_scene = preload("res://player.tscn")
var player_object_list = {}
func _ready():
	# Preconfigure game.
	MultiplayerSystems.player_loaded.rpc_id(1) # Tell the server that this peer has loaded.


# Called only on the server.
func start_game():
	for peer_id in MultiplayerSystems.players.keys():
		var player_character = player_scene.instantiate()
		$EmptyNode.add_child(player_character,true)
		player_character.set_peer_id(peer_id)
		player_object_list[peer_id] = player_character
	# All peers are ready to receive RPCs in this scene.

func _process(delta):
	if player_object_list[multiplayer.get_unique_id()]:
		var localPlayer = player_object_list[multiplayer.get_unique_id()]
		update_pos_and_rot(localPlayer.position,localPlayer.rotation);	

@rpc("any_peer","call_remote","unreliable_ordered")
func update_pos_and_rot(pos,rot):
	var sender_id = multiplayer.get_remote_sender_id();
	player_object_list[sender_id].position = pos;
	player_object_list[sender_id].rotation = rot;



