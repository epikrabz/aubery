extends Area2D

@onready var room_manager: Node2D = $"../../../../../managers/room manager"

@export var target_room: String
@export var spawn_name : String

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		room_manager.call_deferred("change_room",target_room, spawn_name)
