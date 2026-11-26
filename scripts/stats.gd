extends Node

#use this for static shit. stats keyword is for autoload singleton
class_name Stats

static var current
@export var bg_music: AudioStreamPlayer2D
@export var ambient: AudioStreamPlayer2D
@export var inventory: Inv
static var start_scene_on_transition: bool = false
static var flags = {}#JSON object
static var cur_scene: Dictionary[int,String] = {}#ch number : tscn file under res://Scenes/
static var spawn_point: int = 1#not fully implemented
static var fun_value: int = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current = self
	print("current? " , current.inventory)
	cur_scene.set(get_ch_num(),get_tree().current_scene.scene_file_path)
	load_game()
	if fun_value == -1:
		fun_value = randi_range(1, 99)

func get_ch_num():
	var scene_f = get_tree().current_scene.scene_file_path
	var regex = RegEx.new()
	regex.compile(r"Ch([0-9]+)")
	return regex.search(scene_f).get_string(1).to_int()

func bg_music_change(to: float, period: float, new_track: String = "") -> void:
	if new_track == "NONE":
		current.bg_music.stream = null
	elif new_track != "":
		current.bg_music.stream = load("res://sound/" + new_track)
		current.bg_music.play()
	create_tween().tween_property(current.bg_music, "volume_db", to, period)
	pass

func ambient_music_change(to: float, period: float) -> void:
	create_tween().tween_property(current.ambient, "volume_db", to, period)
	pass

static func set_flag(label: String,value):
	var before_value = flags.get(label)
	flags.set(label,value)
	find_nodes_with_meta(current.get_tree().root, label,value)
	if not before_value and label.begins_with("recipe_"):
		item_Get_Anim.start_anim(null,"new recipe (" + label.substr(7) + ")")

const SAVE_PATH = "res://SAVE_DATA.json"
static func save_game():
	if fun_value == -1:
		fun_value = randi_range(1, 99)
	
	var save_data = {
		"cur_scene": cur_scene,
		"spawn_point": spawn_point,
		"inventory": current.inventory.get_item_list(),
		"flags": flags,
		"fun_value":fun_value
	}

	#file.store_string(JSON.stringify(save_data, "\t"))
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data, "\t"))
	file.close()

static func load_game():
	if not FileAccess.file_exists(SAVE_PATH):
		print("No save file found!")
		return false
	if not current:
		print("No active stats to load game with")
		return false

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)

	if file == null:
		print("Failed to open save file!")
		return false
	
	var json_string = file.get_as_text()
	file.close()
	var json = JSON.new()
	var error = json.parse(json_string)

	if error != OK:
		print("Save file is corrupted!")
		return false

	var save_data = json.data
	print(save_data)
	
	#cur_scene.assign(save_data.get("cur_scene", {}))
	for key in save_data.get("cur_scene", {}):
		cur_scene[int(key)] = save_data["cur_scene"][key]
	var d_inv = save_data.get("inventory", {})
	print("current? " , current.inventory)

	flags = save_data.get("flags", {})
	for f in flags:
		find_nodes_with_meta(current.get_tree().root, f,flags[f])
	fun_value = save_data.get("fun_value", {})
	#GameState.inventory = save_data.get("inventory", {})
	#GameState.flags = save_data.get("flags", {})
	#[PROBLEM HERE]
	if current.inventory:
		for p in d_inv:
			current.inventory.quiet_add_item(Inv.find_inv_item("res://Prefabs/Items",p), d_inv[p])

static func find_nodes_with_meta(node: Node, meta_tag: String, value: bool):
	if node.has_meta(meta_tag):
		var default_on = node.get_meta(meta_tag)#true if item is on by default
		#DON VON = off
		#DON VOFF = on
		#DOFF VON = on
		#FOFF VOFF = off
		var on = default_on != value
		if on:
			node.process_mode = Node.PROCESS_MODE_INHERIT
			node.visible = true
		else:
			node.process_mode = Node.PROCESS_MODE_DISABLED
			node.visible = false

	
	for child in node.get_children():
		find_nodes_with_meta(child, meta_tag,value)
