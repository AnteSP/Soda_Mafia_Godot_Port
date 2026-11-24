extends Resource

class_name Inv

@export var item_pairs: Array[InvPair] = []
var InventoryButton: TextureButton

func get_item_list():
	var my_dict: Dictionary[String, int] = {}

	for a in item_pairs:
		my_dict[a.item.name] = a.quantity
	return my_dict

func quiet_add_item(new_item: InvItem, count: int=1):
	var existing = find_pair(new_item)
	if existing:
		existing.quantity += count
		print("adding existing " + new_item.name)
		if existing.quantity == 0:
			item_pairs.remove_at(item_pairs.find(existing))
	else:
		item_pairs.append(InvPair.new(new_item, count))
		print("adding new " + new_item.name)

func add_item(new_item: InvItem, count: int = 1):
	if InventoryButton: InventoryButton.visible = true
	quiet_add_item(new_item,count)
	if count > 0:
		item_Get_Anim.start_anim(new_item)

func find_pair(item: InvItem) -> InvPair:
	for pair in item_pairs:
		if pair.item == item:
			return pair
	return null

func find_pair_z(item: InvItem) -> InvPair:#same thing as find_pair() but never returns null
	for pair in item_pairs:
		if pair.item == item:
			return pair
	return InvPair.new(item, 0)

func item_exists(item_name: String,quantity: int) -> bool:
	for pair in item_pairs:
		if pair.item.name == item_name:
			return pair.quantity >= quantity
	return false
	
static func find_inv_item(directory: String, search_name: String) -> InvItem:
	var dir = DirAccess.open(directory)
	if dir == null:
		return null

	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		var path = directory.path_join(file_name)

		if dir.current_is_dir():
			var result = find_inv_item(path, search_name)
			if result != null:
				dir.list_dir_end()
				return result

		elif file_name.ends_with(".tres"):
			var resource = load(path)
			if resource is InvItem and resource.name == search_name:
				dir.list_dir_end()
				return resource

		file_name = dir.get_next()

	dir.list_dir_end()
	return null
