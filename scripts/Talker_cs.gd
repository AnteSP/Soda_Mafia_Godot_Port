extends AnimationPlayer

class_name TalkerCS

@export var convo = ""
@export var resource: DialogueResource
@export var start_on_ready: bool = true
@export var talkers_disable_on_start: Array[Talker]
@export var disable_on_start: Array[Node]
@export var enable_on_start: Array[Node]
@export var CS_tnoise: AudioStreamPlayer
@export var transition: Node
var start_anim: AnimationPlayer
var label: RichTextLabel
var stopping = false
static var current: TalkerCS = null
var return_to_cam: Camera2D
var balloon
var prev_escape: bool = false
static var skip_prompt_on: bool = false
var fade_instance = null
var set_up_done = false


func _process(_delta):
	if Input.is_key_pressed(KEY_ESCAPE) and not prev_escape and not stopping:
		if skip_prompt_on and balloon:
			balloon.force_finish()
			current.speed_scale = 99
		else:
			fade_instance = load("res://Prefabs/UI/SkipCutscenePopup.tscn").instantiate()
			add_child(fade_instance)
			skip_prompt_on = true
			prev_escape = Input.is_key_pressed(KEY_ESCAPE)
	else:
		prev_escape = Input.is_key_pressed(KEY_ESCAPE)
		if DialogueManagerExampleBalloon.doing_force_finish:
			DialogueManagerExampleBalloon.doing_force_finish = false
			if current:
				current.speed_scale = 1

static func skip_cs_prompt_gone():
	skip_prompt_on = false

static func is_cutscene_happening():
	return current == null

static func call_out(anim= ""):
	if anim != "":
		current.play(anim)

static func do_movement(actor="",posi="",new_speed: float = 100):
	var actor_node = current.get_node(actor)
	if actor_node is NPC_Movement:
		actor_node.set_target(current.get_node("Positions/" + posi).get_path(),new_speed )
		if DialogueManagerExampleBalloon.doing_force_finish:
			await current.get_tree().create_timer(0.05).timeout
			actor_node.position = current.get_node("Positions/" + posi).position

func _ready():
	start_anim = transition.get_node("Transition/AnimationPlayer")
	label = transition.get_node("Transition/RichTextLabel")

	if start_on_ready:
		transition.get_node("Transition").visible = true
		transition.show()
		start_cs()
	else:
		process_mode = Node.PROCESS_MODE_DISABLED

func start_cs():
	print("STARTING CS" , name)
	process_mode = Node.PROCESS_MODE_INHERIT
	current = self
	stopping = false
	stopped_echo = false
	label.text = "Starting cutscene"
	
	player.start_stop_movement(false,"Cutscene")
	
	if start_on_ready:
		set_up_cs()
		DialogueManager.connect("dialogue_ended", post_dialogue_cleanup)
		transition.process_mode = Node.PROCESS_MODE_ALWAYS
		start_anim.process_mode = Node.PROCESS_MODE_ALWAYS
		transition.get_node("Transition").visible = true
		transition.show()
		start_anim.stop()
		start_anim.play("Start_CS")
		start_anim.seek(1)
		start_anim.speed_scale = 1
	else:
		transition.process_mode = Node.PROCESS_MODE_ALWAYS
		start_anim.process_mode = Node.PROCESS_MODE_ALWAYS
		transition.get_node("Transition").visible = true
		transition.show()
		start_anim.stop()
		start_anim.seek(0)
		start_anim.play("Start_CS")
		#DialogueManager.connect("dialogue_ended", post_dialogue_cleanup)
		start_anim.speed_scale = 1
	
	#start_anim.get_parent().move_child(start_anim, start_anim.get_parent().get_child_count() - 1)

func set_up_cs():
	set_up_done = true
	for d in talkers_disable_on_start:
		d.post_dialogue_cleanup(d.resource)
		d.visible = false
		d.process_mode = d.PROCESS_MODE_DISABLED

	for d in disable_on_start:
		d.visible = false
		d.process_mode = d.PROCESS_MODE_DISABLED
	for d in enable_on_start:
		d.visible = true
		d.process_mode = d.PROCESS_MODE_INHERIT
	DialogueManagerExampleBalloon.start_stop_CS(false)
	balloon = DialogueManager.show_dialogue_balloon(resource,convo)
	return_to_cam = get_viewport().get_camera_2d()
	$Camera2D.process_mode = Node.PROCESS_MODE_INHERIT
	$Camera2D.visible = true
	$Camera2D.make_current()
	$Camera2D.set_camera_centre($Positions/CamPos1.position)
	$Camera2D._ready()
	DialogueManagerExampleBalloon.change_type_noise(CS_tnoise)

func post_dialogue_cleanup(_resource: DialogueResource):
	print("post-dialogue cleanup")
	stopping = true
	if fade_instance:
		fade_instance.hide()
	start_anim.stop()
	start_anim.play("Start_CS")
	start_anim.seek(start_anim.get_animation("Start_CS").length-0.4)
	start_anim.speed_scale = -1
	label.text = "Byebye cutscene :3"
	
	if DialogueManagerExampleBalloon.doing_force_finish:
		AudioServer.get_bus_effect(0, 0).pitch_scale = 1
	DialogueManagerExampleBalloon.doing_force_finish = false

func start_stop_CS(start: bool):
	DialogueManagerExampleBalloon.start_stop_CS(start)

func set_good_to_go(go: bool):
	DialogueManagerExampleBalloon.start_stop_CS(go)

func pack_up_attempt():
	if current:
		current.pack_up()

var stopped_echo = false
#Gets called by transition animation
func pack_up():
	
	if(!stopping):
		if not start_on_ready and not set_up_done:
			set_up_cs()
			print("PACKUP prevented- not stopping + setting up")
		else:
			print("PACKUP prevented- not stopping")
		return
	elif(!stopped_echo):
		print("PACKUP prevented- stopping echo")
		DialogueManagerExampleBalloon.change_type_noise(null)
		stopped_echo = true
		return
	print("PACKUP PROCESSING")
	for d in disable_on_start:
		d.visible = true
		d.process_mode = d.PROCESS_MODE_INHERIT
	player.start_stop_movement(true,"Cutscene")
	DialogueManager.disconnect("dialogue_ended",post_dialogue_cleanup)
	current = null
	$Camera2D.process_mode = Node.PROCESS_MODE_DISABLED
	$Camera2D.visible = false
	return_to_cam.make_current()
