extends Camera2D

@export var target_node: Node2D
@export var smoothing := 5.0
@export var max_correction_steps := 20
@export var margin := 20.0  # Safety buffer from edges

@onready var bounds_polygon: PackedVector2Array = _get_boundary_polygon()
@onready var bounds_center := _get_polygon_center(bounds_polygon)

func _process(delta):
	if !target_node || bounds_polygon.is_empty(): return
	
	var desired_pos = target_node.global_position
	var viewport_half = get_viewport_rect().size * 0.5 / zoom
	
	# Get corrected position that keeps camera fully inside bounds
	var safe_pos = _enforce_camera_bounds(desired_pos, viewport_half)
	
	# Apply smoothed movement
	global_position = safe_pos#global_position.lerp(safe_pos, smoothing * delta)

func _enforce_camera_bounds(desired_pos: Vector2, viewport_half: Vector2) -> Vector2:
	var current_pos = global_position
	var test_pos = desired_pos
	
	# First check if desired position is fully valid
	if _is_camera_fully_inside(test_pos, viewport_half):
		return test_pos
	
	# If not, collect all boundary push vectors
	var push_vectors := _get_boundary_push_vectors(test_pos, viewport_half)
	if push_vectors.is_empty():
		return bounds_center  # Fallback
	
	# Calculate combined correction direction
	var combined_push = Vector2.ZERO
	for push in push_vectors:
		combined_push += push
	combined_push = combined_push.normalized()
	
	# Move camera along push direction
	var step_size = viewport_half.length() / max_correction_steps
	for i in max_correction_steps:
		test_pos += combined_push * step_size
		if _is_camera_fully_inside(test_pos, viewport_half):
			break
	
	return test_pos

func _get_boundary_push_vectors(test_pos: Vector2, viewport_half: Vector2) -> Array[Vector2]:
	var corners = [
		test_pos + Vector2(-viewport_half.x, -viewport_half.y),  # Top-left
		test_pos + Vector2(viewport_half.x, -viewport_half.y),   # Top-right
		test_pos + Vector2(viewport_half.x, viewport_half.y),    # Bottom-right
		test_pos + Vector2(-viewport_half.x, viewport_half.y)    # Bottom-left
	]
	
	var push_vectors: Array[Vector2] = []
	
	# Check each corner against the boundary
	for corner in corners:
		if !Geometry2D.is_point_in_polygon(corner, bounds_polygon):
			# Find closest point on boundary to this corner
			var closest_boundary_point := _find_closest_point_on_polygon(corner, bounds_polygon)
			var push = (closest_boundary_point - corner).normalized()
			push_vectors.push_back(push)
	
	return push_vectors

func _find_closest_point_on_polygon(point: Vector2, polygon: PackedVector2Array) -> Vector2:
	var closest_point := Vector2.ZERO
	var min_distance := INF
	
	for i in polygon.size():
		var start = polygon[i]
		var end = polygon[(i + 1) % polygon.size()]
		var segment_point = _closest_point_on_segment(point, start, end)
		var distance = point.distance_to(segment_point)
		
		if distance < min_distance:
			min_distance = distance
			closest_point = segment_point
	
	return closest_point

func _closest_point_on_segment(point: Vector2, segment_start: Vector2, segment_end: Vector2) -> Vector2:
	var segment = segment_end - segment_start
	var t = max(0.0, min(1.0, (point - segment_start).dot(segment) / segment.length_squared()))
	return segment_start + t * segment

func _is_camera_fully_inside(test_pos: Vector2, viewport_half: Vector2) -> bool:
	var corners = [
		test_pos + Vector2(-viewport_half.x, -viewport_half.y),
		test_pos + Vector2(viewport_half.x, -viewport_half.y),
		test_pos + Vector2(viewport_half.x, viewport_half.y),
		test_pos + Vector2(-viewport_half.x, viewport_half.y)
	]
	
	for corner in corners:
		if !Geometry2D.is_point_in_polygon(corner, bounds_polygon):
			return false
	return true

func _get_boundary_polygon() -> PackedVector2Array:
	var bounds_nodes = get_tree().get_nodes_in_group("CameraBounds")
	if bounds_nodes.is_empty(): return PackedVector2Array()
	var bounds_node = bounds_nodes[0]
	if bounds_node.has_node("CollisionPolygon2D"):
		return bounds_node.get_node("CollisionPolygon2D").polygon
	return PackedVector2Array()

func _get_polygon_center(polygon: PackedVector2Array) -> Vector2:
	var center = Vector2.ZERO
	for point in polygon:
		center += point
	return center / polygon.size() if !polygon.is_empty() else Vector2.ZERO
