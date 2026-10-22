class_name item_Get_Anim extends Control

@onready var notis: Array = $Panels.get_children()
@onready var noti_ref: TextureRect = $Panel_ref
static var current: item_Get_Anim = self


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for n in notis:
		n.ref = noti_ref
	current = self
	pass # Replace with function body.

static var last_item = null
static var last_panel = null
static var last_nums = 1
static func start_anim(Item: InvItem):
	#var i = current.notis.size()
	if last_item and Item.name == last_item.name:
		last_nums = last_nums + 1
		last_panel.start_anim(Item.name,Item.texture,last_nums)
		return
	else:
		last_nums = 1
	
	var started_one = false
	for n in current.notis:
		if n.name.ends_with("_ready") and !started_one:
			started_one = true
			n.start_anim(Item.name,Item.texture)
			last_panel = n
		elif n.name.ends_with("anim"):
			n.position.y -= n.size.y
	
	if !started_one:
		var highest_node = current.notis[0]
		for node in current.notis:
			if node.position.y < highest_node.position.y:
				highest_node = node
		highest_node.start_anim(Item.name,Item.texture)
		last_panel = highest_node
	last_item = Item
