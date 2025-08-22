extends Interactable

class_name Talker

@export var convo = ""
@export var resource: DialogueResource
@export var type_noise: AudioStreamPlayer

func Use(_inp):
	DialogueManager.connect("dialogue_started", pre_dialogue_prep)
	DialogueManager.connect("dialogue_ended", post_dialogue_cleanup)
	DialogueManagerExampleBalloon.change_type_noise(type_noise)
	DialogueManager.show_dialogue_balloon(resource,convo)

func pre_dialogue_prep(_resource: DialogueResource):
	type_noise.play()
	player.start_stop_movement(false)
	DialogueManager.disconnect("dialogue_started",pre_dialogue_prep)
	#%DialogueLabel.connect("spoke",typenoise)
	pass

func post_dialogue_cleanup(_resource: DialogueResource):
	type_noise.stop()
	DialogueManager.disconnect("dialogue_ended",post_dialogue_cleanup)
	
