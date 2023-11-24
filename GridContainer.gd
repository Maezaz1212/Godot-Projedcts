extends GridContainer

var player_lobby_display = preload("res://LobbyPlayerDisplay.tscn");
var player_display_list = {};

func _ready():
	MultiplayerSystems.player_connected.connect(_on_main_menu_player_connected)
	MultiplayerSystems.player_disconnected.connect(_on_main_menu_player_disconnected)
	MultiplayerSystems.server_disconnected.connect(_on_main_menu_server_disconnected)
	
func _on_main_menu_player_connected(peer_id, player_info):
	var display_instance = player_lobby_display.instantiate();
	add_child(display_instance);
	display_instance.get_node("NameLabel").text = player_info.keys()[0];
	player_display_list[peer_id] = display_instance



func _on_main_menu_player_disconnected(peer_id):
	player_display_list[peer_id].queue_free();
	player_display_list.erase(peer_id);



func _on_main_menu_server_disconnected():
	for key in player_display_list.keys():
		var player_display = player_display_list[key];
		if(player_display != null):
			player_display.queue_free();
			player_display_list.erase(key);
			
		
