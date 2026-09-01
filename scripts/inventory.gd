extends Resource

class_name Inv

@export var item_pairs: Array[InvPair] = []
var InventoryButton: TextureButton


func add_item(new_item: InvItem, count: int = 1):
	var existing = find_pair(new_item)
	if InventoryButton: InventoryButton.visible = true
	
	if existing:
		existing.quantity += count
		print("adding existing " + new_item.name)
	else:
		item_pairs.append(InvPair.new(new_item, count))
		print("adding new " + new_item.name)
	item_Get_Anim.start_anim(new_item)

func find_pair(item: InvItem) -> InvPair:
	for pair in item_pairs:
		if pair.item == item:
			return pair
	return null

func item_exists(item_name: String,quantity: int) -> bool:
	for pair in item_pairs:
		if pair.item.name == item_name:
			return pair.quantity >= quantity
	return false
