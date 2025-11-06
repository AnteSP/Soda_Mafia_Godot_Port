extends AnimationPlayer

class_name TalkerCS

@export var convo = ""
@export var resource: DialogueResource
@export var start_on_ready: bool = true
@export var disable_on_start: Array[Node]
@export var CS_tnoise: AudioStreamPlayer
@export var transition: Node
var start_anim: AnimationPlayer
var label: RichTextLabel
var stopping = false
static var current: TalkerCS = null
var return_to_cam: Camera2D
var balloon

static func is_cutscene_happening():
	return current == null

static func call_out(anim= ""):
	print("beh")
	if anim != "":
		current.play(anim)

static func do_movement(actor="",posi="",new_speed: float = 100):
	var actor_node = current.get_node(actor)
	if actor_node is NPC_Movement:
		actor_node.set_target(current.get_node("Positions/" + posi).get_path(),new_speed)

func _ready():
	start_anim = transition.get_node("Transition/AnimationPlayer")
	label = transition.get_node("Transition/RichTextLabel")

	if start_on_ready:
		transition.get_node("Transition").visible = true
		transition.show()
		start_cs()

func start_cs():
	current = self
	stopping = false
	stopped_echo = false
	label.text = "Starting cutscene"
	DialogueManager.connect("dialogue_ended", post_dialogue_cleanup)
	player.start_stop_movement(false)
	DialogueManagerExampleBalloon.change_type_noise(CS_tnoise)

	start_anim.play("Start_CS")
	if start_on_ready:
		start_anim.seek(1)

	for d in disable_on_start:
		d.visible = false
		d.process_mode = d.PROCESS_MODE_DISABLED
	DialogueManagerExampleBalloon.start_stop_CS(false)
	balloon = DialogueManager.show_dialogue_balloon(resource,convo)
	print("type: " , balloon.get_class() )
	return_to_cam = get_viewport().get_camera_2d()
	$Camera2D.process_mode = Node.PROCESS_MODE_INHERIT
	$Camera2D.visible = true
	$Camera2D.make_current()
	$Camera2D.set_camera_centre($Positions/CamPos1.position)
	
	print("Camera status: " , $Camera2D.visible)
	#start_anim.get_parent().move_child(start_anim, start_anim.get_parent().get_child_count() - 1)
	
func post_dialogue_cleanup(_resource: DialogueResource):
	start_anim.stop()
	start_anim.play("Start_CS")
	start_anim.seek(start_anim.get_animation("Start_CS").length-0.4)
	start_anim.speed_scale = -1
	label.text = "Byebye cutscene :3"
	stopping = true

func start_stop_CS(start: bool):
	DialogueManagerExampleBalloon.start_stop_CS(start)

func set_good_to_go(go: bool):
	DialogueManagerExampleBalloon.start_stop_CS(go)

var stopped_echo = false
func pack_up():
	print("CALLED PACKUP")
	if(!stopping):return
	elif(!stopped_echo):
		DialogueManagerExampleBalloon.change_type_noise(null)
		stopped_echo = true
		return
	for d in disable_on_start:
		d.visible = true
		d.process_mode = d.PROCESS_MODE_INHERIT
	player.start_stop_movement(true)
	DialogueManager.disconnect("dialogue_ended",post_dialogue_cleanup)
	current = null
	$Camera2D.process_mode = Node.PROCESS_MODE_DISABLED
	$Camera2D.visible = false
	return_to_cam.make_current()

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		balloon.next(resource.get_next_dialogue_line())
