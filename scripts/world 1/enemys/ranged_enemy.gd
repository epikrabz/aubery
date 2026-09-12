extends CharacterBody2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var floor_check: RayCast2D = $floor_check
@onready var atk_cooldown: Timer = $"atk cooldown"

enum State {PATROL, CHASE, ATTACK}

@export var patrol_distance = 300

var SPEED = 100
var state = State.PATROL
var patrol_dir = 1
var patrol_start: float
var health = 50
var turn_cooldown := 0.0
var on_atk_cooldown = false

func _ready() -> void:
	patrol_start = global_position.x

func flip_raycast(dir: int) -> void:
	floor_check.position.x = abs(floor_check.position.x) * dir

func _physics_process(delta: float) -> void:
	if health <= 0:
		queue_free()

	turn_cooldown -= delta

	var diff = player.global_position - global_position
	var dist = global_position.distance_to(player.global_position)
	var on_same_lvl = diff.y < 100 and diff.y > -200

	if dist < 300 and on_same_lvl:
		state = State.ATTACK
	elif dist < 600 and on_same_lvl:
		state = State.CHASE
	else:
		state = State.PATROL

	match state:
		State.PATROL:
			SPEED = 55
			flip_raycast(patrol_dir)
			velocity.x = patrol_dir * SPEED
			var at_ledge = not floor_check.is_colliding()
			if (is_on_wall() or at_ledge or abs(global_position.x - patrol_start) >= patrol_distance) and turn_cooldown <= 0:
				patrol_dir *= -1
				patrol_start = global_position.x
				turn_cooldown = 0.1
 
		State.CHASE:
			SPEED = 85
			var chase_dir = sign(diff.x)
			flip_raycast(chase_dir)
			if floor_check.is_colliding():
				velocity.x = chase_dir * SPEED
			else:
				velocity.x = 0

		State.ATTACK:
			velocity.x = 0
			if on_atk_cooldown == false:
				atk_cooldown.start()
				on_atk_cooldown = true
				shoot()

	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()

func shoot():
	var projectile = load("res://scenes/world1/enemys/projectiles/projectile_1.tscn").instantiate()
	add_sibling(projectile)
	projectile.global_position = global_position
	projectile.velocity = ((player.global_position + Vector2(0,-50)) - global_position) * 1.5
	print(projectile.velocity)

func _on_atk_cooldown_timeout() -> void:
	on_atk_cooldown = false
