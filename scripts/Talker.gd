extends Interactable

class_name Talker

static var active_balloons := []
static var active_talker: Talker

@export var convo = ""
@export var resource: DialogueResource
@export var type_noise: AudioStreamPlayer
var balloon


func Use(_inp):
	DialogueManager.connect("dialogue_started", pre_dialogue_prep)
	DialogueManager.connect("dialogue_ended", post_dialogue_cleanup)
	DialogueManagerExampleBalloon.change_type_noise(type_noise)
	for b in active_balloons:
		b.queue_free()
		active_balloons.erase(b)
	balloon = DialogueManager.show_dialogue_balloon(resource,convo)
	active_balloons.append(balloon)
	active_talker = self

func pre_dialogue_prep(_resource: DialogueResource):
	if type_noise:
		type_noise.play()
	if is_in_group("Auto_Interact"):
		remove_from_group("Auto_Interact")
		get_child(0).disabled = true
	else:
		player.start_stop_movement(false,"Interaction")
	DialogueManager.disconnect("dialogue_started",pre_dialogue_prep)
	#%DialogueLabel.connect("spoke",typenoise)
	pass

func post_dialogue_cleanup(_resource: DialogueResource):
	if type_noise:
		type_noise.stop()
	DialogueManagerExampleBalloon.change_type_noise(null)
	DialogueManager.disconnect("dialogue_ended",post_dialogue_cleanup)
	active_balloons.erase(balloon)
	active_talker = null
	
static func face_player():
	if not active_talker: return
	var xdist = active_talker.position.x - player.current.position.x
	var ydist = active_talker.position.y - player.current.position.y
	if abs(xdist) > abs(ydist):
		if xdist < 0: active_talker.get_node("AnimatedSprite2D").play("idle_right")
		else: active_talker.get_node("AnimatedSprite2D").play("idle_left")
	else:
		if ydist < 0: active_talker.get_node("AnimatedSprite2D").play("idle_down")
		else: active_talker.get_node("AnimatedSprite2D").play("idle_up")
	pass
