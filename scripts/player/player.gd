extends CharacterBody2D

@onready var hit_area: Area2D = $"png/hit area"

@onready var png: Node2D = $png

var is_flying = false
var health = 100

const SPEED = 300.0

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		sword_attack()

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept"):
		is_flying = true
	if Input.is_action_just_released("ui_accept"):
		is_flying = false

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		if direction > 0:
			png.scale.x = 1
		else:
			png.scale.x = -1
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if is_flying:
		if velocity.y > -170:
			velocity.y -= 30
		else:
			velocity.y = -200

		rotation = move_toward(rotation, deg_to_rad(15 * direction), 0.015)
	else:
		rotation = move_toward(rotation, 0, 0.058)

	move_and_slide()

	if health <= 0:
		get_tree().reload_current_scene()

func sword_attack():
	for body in hit_area.get_overlapping_bodies():
		if body.is_in_group("enemy"):
			body.health -= 49
