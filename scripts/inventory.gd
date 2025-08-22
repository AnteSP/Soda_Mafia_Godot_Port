extends Resource

class_name Inv

@export var item_pairs: Array[InvPair] = []


func add_item(new_item: InvItem, count: int = 1):
	var existing = find_pair(new_item)
	if existing:
		existing.quantity += count
	else:
		item_pairs.append(InvPair.new(new_item, count))

func find_pair(item: InvItem) -> InvPair:
	for pair in item_pairs:
		if pair.item == item:
			return pair
	return null
