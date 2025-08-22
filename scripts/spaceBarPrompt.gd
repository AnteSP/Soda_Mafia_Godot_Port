extends Area2D

class_name SpaceBarPrompt

var space_bar_prompt_reference
var space_bar_innactive
var c_bod
var progress_bar


func _ready() -> void:
	space_bar_prompt_reference = get_node("Spacebar")
	space_bar_innactive = space_bar_prompt_reference.global_position
	progress_bar = get_node("Spacebar/ProgressBar")

func get_closest_body(filter_groups: Array = []) -> PhysicsBody2D:
	var closest_body: PhysicsBody2D = null
	var closest_distance_sq: float = INF
	var center_position: Vector2 = global_position
	
	for body in get_overlapping_bodies():
		if filter_groups.size() > 0 and not body.is_in_group(filter_groups[0]):
			continue
		var distance_sq = center_position.distance_squared_to(body.global_position)
		if distance_sq < closest_distance_sq:
			closest_distance_sq = distance_sq
			closest_body = body
	
	return closest_body

var stopped = false
func interact_with_c_bod():
	if not c_bod:
		reset_spacebar()
		return false

	already_reset = false
	space_bar_prompt_reference.play("pressed")
	space_bar_prompt_reference.self_modulate = Color(0.3,0.3,0.3,0.46)
	if c_bod is Interactable:
		#c_bod.Use(1)
		progress_bar.start_progress(c_bod.use_time,c_bod)
		return true
	else:
		return false

var already_reset = false

func reset_spacebar():
	stopped = false
	if(already_reset):return
	space_bar_prompt_reference.play("default")
	space_bar_prompt_reference.self_modulate = Color(1,1,1,0.46)
	already_reset = true

var last_c_bod: String = ""
func _physics_process(_delta):
	if stopped:return
	c_bod = get_closest_body(["Interactable"])
	if c_bod:
		space_bar_prompt_reference.global_position = c_bod.global_position + Vector2(0, -25)
		if(c_bod.name != last_c_bod):
			changed_c_bod()
		last_c_bod = c_bod.name
	else:
		space_bar_prompt_reference.global_position = space_bar_innactive
		if(last_c_bod != ""):
			changed_c_bod()
			last_c_bod = ""

func changed_c_bod():
	progress_bar.reset_timer()
	pass

func _on_progress_bar_progress_completed() -> void:
	print("IT DID IT!!!!")
