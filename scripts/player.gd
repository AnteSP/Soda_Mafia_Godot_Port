extends CharacterBody2D

const speed = 100
var actual_speed : float = 0
var current_dir = "down"
@export var sbp: SpaceBarPrompt
@export var Inv: Inv
var interactable

func _ready():
	interactable = sbp.get_node("interactable")
	DialogueManager.connect("dialogue_ended", post_dialogue_cleanup)

func _physics_process(delta):
	player_movement(delta)

var stopped = false

func player_movement(_delta):
	if stopped:
		return
	
	if Input.is_action_just_pressed("Space"):
		$AnimatedSprite2D.play("idle_" + current_dir)
		if sbp.interact_with_c_bod():
			stopped = true
		else:
			stopped = false
		return
	elif Input.is_action_just_released("Space"):
		sbp.reset_spacebar()
	
	var input_dir = Input.get_vector("A", "D", "W", "S")
	if Input.is_action_pressed("Shift"):
		actual_speed = speed/3
	else:
		actual_speed = speed
	velocity = input_dir * actual_speed
	move_and_slide()
	
	# Update animation only if there's movement input
	if input_dir != Vector2.ZERO:
		update_animation("walk", input_dir)
	else:
		update_animation("idle", input_dir)
		


func post_dialogue_cleanup(resource: DialogueResource):
	# Your code to execute when dialogue ends
	print("Dialogue ended with resource: ", resource)
	sbp.reset_spacebar()
	stopped = false

func update_animation(state: String, input_dir: Vector2):

	# Determine direction (prioritizes horizontal over vertical)
	var offset = 20
	if input_dir.x < 0:
		current_dir = "left"
		interactable.position = Vector2(-1,0)*offset
	elif input_dir.x > 0:
		current_dir = "right"
		interactable.position = Vector2(1,0)*offset
	elif input_dir.y < 0:
		current_dir = "up"
		interactable.position = Vector2(0,-1)*offset
	elif input_dir.y > 0:
		current_dir = "down"
		interactable.position = Vector2(0,1)*offset
		
	if current_dir == "none":
		return
	# Play animation (e.g., "walk_left" or "idle_down")
	$AnimatedSprite2D.play(state + "_" + current_dir)
	$AnimatedSprite2D.speed_scale = actual_speed/100
