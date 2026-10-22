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

func interaction_in_progress():
	if progress_bar.progress_duration > 0 and progress_bar.cached_interactable:
		return true
	return false

func get_closest_body(filter_groups: Array = []) -> PhysicsBody2D:
	if filter_groups.size() <= 0:
		return null
	
	var closest_body: PhysicsBody2D = null
	var closest_distance_sq: float = INF
	var center_position: Vector2 = global_position
	
	for body in get_overlapping_bodies():
		if body.is_in_group("Boundary"):
			body.get_parent().pulsate_barrier()
		elif body.is_in_group("Auto_Interact"):
			body.Use(0)
		if progress_bar.cached_interactable:
			continue
		if not body.is_in_group(filter_groups[0]):
			continue
		var distance_sq = center_position.distance_squared_to(body.global_position)
		if distance_sq < closest_distance_sq:
			closest_distance_sq = distance_sq
			closest_body = body
	
	if progress_bar.cached_interactable:
		if progress_bar.cached_interactable in get_overlapping_bodies():
			return progress_bar.cached_interactable
		else:
			return null
	
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
	keep_c_bod = false

var last_c_bod: String = ""
var keep_c_bod: bool = false
func _physics_process(_delta):
	if stopped:return
	c_bod = get_closest_body(["Interactable"])
	if keep_c_bod:return
	if c_bod:
		space_bar_prompt_reference.global_position = c_bod.global_position + Vector2(0, -25)
		if(c_bod.name != last_c_bod):
			changed_c_bod()
		last_c_bod = c_bod.name
		if c_bod is Interactable and c_bod.always_in_focus and progress_bar.timer.time_left > 0:
			keep_c_bod = true
	else:
		space_bar_prompt_reference.global_position = space_bar_innactive
		if(last_c_bod != ""):
			changed_c_bod()
			last_c_bod = ""

func changed_c_bod():
	progress_bar.reset_timer()
	reset_spacebar()
	pass

func _on_progress_bar_progress_completed() -> void:
	#reset_spacebar()
	player.just_pressed = false
	keep_c_bod = false
	pass
