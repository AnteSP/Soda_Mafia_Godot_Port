extends CharacterBody2D
class_name NPC_Movement

@export var speed: float = 100.0
@export var target_path: NodePath
@export var stop_distance: float = 5.0
var current_dir = "down"

func set_target(target: NodePath,new_speed:float = 100):
	target_path = target
	speed = new_speed

func _physics_process(_delta):
	if not target_path:
		return

	var target = get_node(target_path)
	var direction = target.global_position - global_position
	var distance = direction.length()

	if distance > stop_distance:
		velocity = direction.normalized() * speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		
		# Update animation only if there's movement input
	if velocity != Vector2.ZERO:
		update_animation("walk", velocity)
	else:
		update_animation("idle", velocity)

func update_animation(state: String, input_dir: Vector2):
	# Determine direction (prioritizes horizontal over vertical)
	if input_dir.x < 0 and input_dir.x < input_dir.y:
		current_dir = "left"
	elif input_dir.x > 0 and input_dir.x > input_dir.y:
		current_dir = "right"
	elif input_dir.y < 0:
		current_dir = "up"
	elif input_dir.y > 0:
		current_dir = "down"
		
	if current_dir == "none":
		return
	# Play animation (e.g., "walk_left" or "idle_down")
	$AnimatedSprite2D.play(state + "_" + current_dir)
	$AnimatedSprite2D.speed_scale = speed/20
