extends Camera2D

@export var zoom_speed := 0.1      # How fast to zoom
@export var min_zoom := 0.5       # Closest zoom
@export var max_zoom := 3.0       # Farthest zoom
@export var zoom_step := 0.25     # Zoom increment

# Mouse influence settings
@export var mouse_influence_strength := 0.5  # How much mouse affects camera
@export var mouse_influence_radius := 200.0  # Pixels from center where influence starts
@export var return_speed := 3.0  # How quickly camera returns to center

var cam_centre: Vector2 = Vector2.ZERO

func set_camera_centre(new_cam_centre: Vector2):
	cam_centre = new_cam_centre

func _unhandled_input(event):
	if event is InputEventMouseButton:
		# Zoom in/out with mouse wheel
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_camera(-zoom_step)  # Zoom in
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_camera(zoom_step)   # Zoom out

func zoom_camera(amount: float):
	# Calculate new zoom level with clamping
	var new_zoom = zoom + Vector2.ONE * amount * zoom_speed
	new_zoom = new_zoom.clamp(Vector2.ONE * min_zoom, Vector2.ONE * max_zoom)
	
	# Apply smoothed zoom (optional)
	zoom = lerp(zoom, new_zoom, 0.2)


func _process(delta):

	var mouse_pos_screen = get_viewport().get_mouse_position()
	var viewport_rect = get_viewport().get_visible_rect()
	
	if !viewport_rect.has_point(mouse_pos_screen):
		position = cam_centre
		return

	# Calculate mouse influence
	var mouse_pos = get_global_mouse_position()
	
	var mouse_offset = mouse_pos - global_position
	var distance_from_center = mouse_offset.length()
	
	var mouse_influence = cam_centre
	if distance_from_center > mouse_influence_radius:
		var influence_dir = mouse_offset.normalized()
		var influence_amount = min((distance_from_center - mouse_influence_radius) / 100.0, 1.0)
		mouse_influence += influence_dir * mouse_influence_strength * influence_amount
	
	# Combine positions
	var target_position = mouse_influence
	
	# Smooth movement
	position = position.lerp(target_position, return_speed * delta)
