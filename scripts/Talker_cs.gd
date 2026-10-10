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
@export var end_with_scene: PackedScene = null
var stopping = false
static var current: TalkerCS = null
var return_to_cam: Camera2D
var balloon
var prev_escape: bool = false
static var skip_prompt_on: bool = false
var fade_instance = null
var set_up_done = false
static var stopping_movers: Array[NPC_Movement]


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

static func do_movement(actor="",posi="",new_speed: float = 100,do_stopping: bool = false):
	var actor_node = current.get_node(actor)
	if actor_node is NPC_Movement:
		if do_stopping:
			stopping_movers.append(actor_node)
		actor_node.set_target(current.get_node("Positions/" + posi).get_path(),new_speed )
		if DialogueManagerExampleBalloon.doing_force_finish:
			await current.get_tree().create_timer(0.05).timeout
			actor_node.position = current.get_node("Positions/" + posi).position

func _ready():
	if start_on_ready:
		#Transition.start_cuscene(true)
		#transition.get_node("Transition").visible = true
		#transition.show()
		start_cs()
	else:
		process_mode = Node.PROCESS_MODE_DISABLED

func start_cs():
	print("STARTING CS" , name)
	process_mode = Node.PROCESS_MODE_INHERIT
	current = self
	stopping = false
	stopped_echo = false
	
	player.start_stop_movement(false,"Cutscene")
	
	if start_on_ready:
		set_up_cs()
		Transition.start_cuscene(true)
	else:
		Transition.start_cuscene(false)

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
	DialogueManager.connect("dialogue_ended", post_dialogue_cleanup)

func post_dialogue_cleanup(_resource: DialogueResource):
	print("post-dialogue cleanup")
	stopping = true
	if fade_instance:
		fade_instance.hide()
	Transition.end_cutscene()
	if DialogueManagerExampleBalloon.doing_force_finish:
		AudioServer.get_bus_effect(0, 0).pitch_scale = 1
	DialogueManagerExampleBalloon.doing_force_finish = false

func start_stop_CS(start: bool):
	DialogueManagerExampleBalloon.start_stop_CS(start)

func set_good_to_go(go: bool):
	DialogueManagerExampleBalloon.start_stop_CS(go)

static func is_anything_stopping_cs():
	for m in stopping_movers:
		if m.velocity == Vector2.ZERO:
			stopping_movers.erase(m)
		else:
			return true
	return false

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
	elif(!stopped_echo and start_on_ready and false):#THIS IS HOPEFULLY DEPRECATED
		print("PACKUP prevented- stopping echo [THIS SHOULD NOT HAVE HAPPENED]")
		DialogueManagerExampleBalloon.change_type_noise(null)
		stopped_echo = true
		return
	print("PACKUP PROCESSING")
	for d in disable_on_start:
		d.visible = true
		d.process_mode = d.PROCESS_MODE_INHERIT
	for d in enable_on_start:
		d.visible = false
		d.process_mode = d.PROCESS_MODE_DISABLED
	player.start_stop_movement(true,"Cutscene")
	DialogueManager.disconnect("dialogue_ended",post_dialogue_cleanup)
	current = null
	$Camera2D.process_mode = Node.PROCESS_MODE_DISABLED
	$Camera2D.visible = false
	return_to_cam.make_current()
	if end_with_scene:
		stats.start_scene_on_transition = true
		get_tree().change_scene_to_packed(end_with_scene)
