extends Camera2D

@export var target: Node2D

@export var follow_speed := 6.0
@export var look_ahead_distance := 80.0
@export var look_ahead_speed := 4.0

var look_ahead := Vector2.ZERO

func _ready():
	position_smoothing_enabled = true
	position_smoothing_speed = follow_speed

func _process(delta):
	if target == null:
		return

	var input_x := Input.get_axis("left", "right")

	var desired_look_ahead := Vector2(input_x * look_ahead_distance, 0)
	look_ahead = look_ahead.lerp(desired_look_ahead, delta * look_ahead_speed)

	global_position = target.global_position + look_ahead
