extends Interactable

@export var item: InvItem
@export var quantity: int
@export var inventory: Inv

#inp is the amount we're taking
func Use(_inp: int):
	inventory.add_item(item,quantity)
	player.start_stop_movement(true)
	self.visible = false
	self.remove_from_group("Interactable")
	
