extends StaticBody2D

class_name Pulsation

@onready var collision_polygon = $CollisionShape
@onready var visual_polygon = $Polygon2D
var pulsable = true
var animating = false
var tween

func _ready():
	# Copy the collision shape to the visual polygon
	visual_polygon.polygon = collision_polygon.polygon

	# Set a color for the polygon
	visual_polygon.color = Color(1, 0, 0, 0)

func start_stop_pulsing(start: bool):
	pulsable = start

func interrupt_pulsating():
	if pulsable:
		if tween:
			tween.kill()
			visual_polygon.color = Color(1, 0, 0, 0)
			pulsable = false
			animating = false

func pulsate_barrier():
	if(animating or not pulsable): 
		return
	# Create a tween for smooth animation
	animating = true
	tween = create_tween()
	print("trying pulsate")
	
	# Start fully transparent
	visual_polygon.color = Color(1, 0, 0, 0)

	# Fade in to 0.5 over 0.8s
	tween.tween_property(visual_polygon,"color",Color(1, 0, 0, 0.3),0.6)

	# Fade back to 0 over another 0.8s
	tween.tween_property(visual_polygon,"color",Color(1, 0, 0, 0),0.6)

	await tween.finished
	pulsable = false
	animating = false
	#tween.tween_property(player.current,"")
