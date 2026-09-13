extends CharacterBody2D
class_name enemy

@onready var player = get_tree().get_first_node_in_group("player")
@onready var floor_check: RayCast2D = $floor_check

enum State {PATROL, CHASE, ATTACK}

@export var patrol_distance = 300

var speed = 200
var state = State.PATROL
var patrol_dir = 1
var patrol_start: float
var health = 50
var turn_cooldown = 0.0
var attack_cool_down = 0.5

func _ready() -> void:
	patrol_start = global_position.x

func flip_raycast(dir: int) -> void:
	floor_check.position.x = abs(floor_check.position.x) * dir

func _physics_process(delta: float) -> void:
	speed *= delta
	
	if health <= 0:
		queue_free()

	turn_cooldown -= delta

	var diff = player.global_position - global_position
	var dist = global_position.distance_to(player.global_position)
	var on_same_lvl = diff.y < 100 and diff.y > -200

	if dist < 50 and on_same_lvl:
		state = State.ATTACK
	elif dist < 600 and on_same_lvl:
		state = State.CHASE
	else:
		state = State.PATROL

	match state:
		State.PATROL:
			speed = 60
			flip_raycast(patrol_dir)
			velocity.x = patrol_dir * speed
			var at_ledge = not floor_check.is_colliding()
			if (is_on_wall() or at_ledge or abs(global_position.x - patrol_start) >= patrol_distance) and turn_cooldown <= 0:
				patrol_dir *= -1
				patrol_start = global_position.x
				turn_cooldown = 0.1
 
		State.CHASE:
			speed = 100
			var chase_dir = sign(diff.x)
			flip_raycast(chase_dir)
			velocity.x = chase_dir * speed

		State.ATTACK:
			velocity.x = 0
			if attack_cool_down <=0:
				player.health -= 20
				attack_cool_down = 1
			else:
				attack_cool_down -= delta

	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()
