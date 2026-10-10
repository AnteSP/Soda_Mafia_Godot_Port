extends CanvasLayer

var anim: AnimationPlayer
var label: RichTextLabel
#static var current: Transition = self
var custom_text: String = ""

func set_custom_text(to_this: String= ""):
	custom_text = to_this
	label.text = custom_text
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim = get_node("Transition/AnimationPlayer")
	label = get_node("Transition/RichTextLabel")
	pass # Replace with function body.

func start_cuscene(instant: bool= false):
	Transition.show()
	print("ATTEMPTING START")
	#transition.process_mode = Node.PROCESS_MODE_ALWAYS
	#start_anim.process_mode = Node.PROCESS_MODE_ALWAYS
	#transition.get_node("Transition").visible = true
	#transition.show()
	anim.stop()
	if instant:
		print("ATTEMPTING INSTANT")
		anim.seek(1,true)
	else:
		anim.seek(0,true)
	anim.play("Start_CS")
	if instant:
		anim.seek(1,true)

	anim.speed_scale = 1
	label.text = "Starting Cutscene" if custom_text == "" else custom_text

func end_cutscene():
	Transition.visible = true
	anim.stop()
	anim.seek(anim.get_animation("Start_CS").length-0.4)
	anim.speed_scale = -1
	anim.play("Start_CS")
	label.text = "Ending Cutscene" if custom_text == "" else custom_text
	pass
