extends Node2D

@onready var world: Node2D = $"../../world"
@onready var player: CharacterBody2D = $"../../player/player"
@onready var camera_2d: Camera2D = $"../../player/Camera2D"


func change_room(path, spawn_name):

	var current_room = world.get_node_or_null("CurrentRoom")

	if current_room:
		current_room.name = "old"
		current_room.queue_free()

	var room = load(path).instantiate()

	world.add_child(room)
	room.name = "CurrentRoom"

	var player_spawn = room.get_node("markers/spawn_positions/" + spawn_name + "_player")
	var camera_spawn = room.get_node("markers/spawn_positions/" + spawn_name + "_camera")

	player.global_position = player_spawn.global_position
	camera_2d.global_position = camera_spawn.global_position

	var top_left = room.get_node("markers/camera_boarders/top_left")
	var bottom_right = room.get_node("markers/camera_boarders/bottom_right")

	camera_2d.limit_left = int(top_left.global_position.x)
	camera_2d.limit_top = int(top_left.global_position.y)
	camera_2d.limit_right = int(bottom_right.global_position.x)
	camera_2d.limit_bottom = int(bottom_right.global_position.y)
