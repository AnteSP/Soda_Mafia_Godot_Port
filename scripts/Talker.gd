extends StaticBody2D

class_name Talker

@export var convo = ""
@export var resource: DialogueResource
@export var type_noise: AudioStreamPlayer

func Talk_Tuah():
	DialogueManager.connect("dialogue_started", pre_dialogue_prep)
	DialogueManager.connect("dialogue_ended", post_dialogue_cleanup)
	DialogueManagerExampleBalloon.change_type_noise(type_noise)
	DialogueManager.show_dialogue_balloon(resource,convo)

func pre_dialogue_prep(resource: DialogueResource):
	print("GOT HERE")
	type_noise.play()
	DialogueManager.disconnect("dialogue_started",pre_dialogue_prep)
	#%DialogueLabel.connect("spoke",typenoise)
	pass

func post_dialogue_cleanup(resource: DialogueResource):
	type_noise.stop()
	DialogueManager.disconnect("dialogue_ended",post_dialogue_cleanup)
	
