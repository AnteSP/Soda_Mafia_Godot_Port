class_name InvPair extends Resource
@export var item: InvItem
@export var quantity: int = 1

func _init(p_item: InvItem = null, p_quantity: int = 1):
	item = p_item
	quantity = p_quantity
