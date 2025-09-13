extends Node

@export var convo = ""
@export var resource: DialogueResource
@export var start_on_ready: bool = true
@export var disable_on_start: Array[Node]
@export var CS_tnoise: AudioStreamPlayer
@export var start_anim: AnimationPlayer
@export var label: RichTextLabel
var stopping = false

func _ready():
	if start_on_ready:
		start_cs()

func start_cs():
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
	DialogueManager.show_dialogue_balloon(resource,convo)
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
