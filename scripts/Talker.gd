extends Interactable

class_name Talker

static var active_balloons := []

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

func pre_dialogue_prep(_resource: DialogueResource):
	type_noise.play()
	if is_in_group("Auto_Interact"):
		remove_from_group("Auto_Interact")
		get_child(0).disabled = true
	else:
		player.start_stop_movement(false)
	DialogueManager.disconnect("dialogue_started",pre_dialogue_prep)
	#%DialogueLabel.connect("spoke",typenoise)
	pass

func post_dialogue_cleanup(_resource: DialogueResource):
	type_noise.stop()
	DialogueManagerExampleBalloon.change_type_noise(null)
	DialogueManager.disconnect("dialogue_ended",post_dialogue_cleanup)
	active_balloons.erase(balloon)
	
