extends CharacterBody2D
class_name player

const speed = 100
var actual_speed : float = 0
var current_dir = "down"
@export var sbp: SpaceBarPrompt
@export var Inventory: Inv
var interactable
static var current: player
@onready var boundary_pulsation = get_tree().get_first_node_in_group("Boundary").get_parent()

func _ready():
	interactable = sbp.get_node("interactable")
	DialogueManager.connect("dialogue_ended", post_dialogue_cleanup)
	current = self

func _physics_process(delta):
	#print("Stopped- " , stopped)
	if Input.is_action_just_released("Space"):
		sbp.reset_spacebar()
		just_pressed = false
	player_movement(delta)

static var stopped = false
static var just_pressed = false

func player_movement(_delta):
	if stopped:
		return
	
	if Input.is_action_just_pressed("Space") && !just_pressed:
		$AnimatedSprite2D.play("idle_" + current_dir)
		just_pressed = true
		if sbp.interact_with_c_bod():
			pass
			#stopped = true
		return

	var input_dir = Input.get_vector("A", "D", "W", "S")
	if Input.is_action_pressed("Shift"):
		actual_speed = float(speed)/3
	else:
		actual_speed = speed
	velocity = input_dir * actual_speed
	move_and_slide()
	
	# Update animation only if there's movement input
	if input_dir != Vector2.ZERO:
		update_animation("walk", input_dir)
		boundary_pulsation.start_stop_pulsing(true)
	else:
		update_animation("idle", input_dir)
		boundary_pulsation.interrupt_pulsating()
		

static func start_stop_movement(start: bool):
	
	stopped = !start
	print("STOPPED PLAYER " , stopped)

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

func dissapear():
	$Camera2D.visible = false
	$Camera2D.process_mode = $Camera2D.PROCESS_MODE_DISABLED
	
func reappear():
	$Camera2D.visible = true
	$Camera2D.process_mode = $Camera2D.PROCESS_MODE_INHERIT
