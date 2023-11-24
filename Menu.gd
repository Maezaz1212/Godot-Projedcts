extends Control
#Button Functions
func _on_host_button_button_down():
	MultiplayerSystems.create_game()


func _on_join_button_button_down():
	MultiplayerSystems.join_game()


func _on_ip_text_changed(new_text):
	MultiplayerSystems.ip = new_text



func _on_name_text_changed(new_text):
	MultiplayerSystems.player_info = {new_text :  new_text}


func _on_disconnect_button_down():
	MultiplayerSystems._on_server_disconnected()
	


func _on_start_game_button_down():
	MultiplayerSystems.load_game.rpc("res://game.tscn")
