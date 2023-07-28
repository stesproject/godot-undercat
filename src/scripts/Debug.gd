extends Node

@onready var players = get_tree().get_nodes_in_group("player")


func _unhandled_key_input(event):
	if event.is_action_pressed("pass-through"):
		_toggle_players_collision()
	elif event.is_action_pressed("full-recovery"):
		_full_recovery_players()
	elif event.is_action_pressed("grass-shader"):
		_toggle_grass_shader()


func _toggle_players_collision():
	for player in players:
		if player is PlayerEntity:
			player.collision_shape.disabled = !player.collision_shape.disabled


func _full_recovery_players():
	for player in players:
		if player is PlayerEntity:
			player.hp = player.max_hp


func _toggle_grass_shader():
	for player in players:
		if player is CharacterEntity:
			player.toggle_grass_zone()
