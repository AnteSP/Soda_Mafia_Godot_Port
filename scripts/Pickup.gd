extends Interactable

@export var item: InvItem
@export var quantity: int
@export var inventory: Inv

#inp is the amount we're taking
func Use(_inp: int):
	for i in range(quantity):
		inventory.add_item(item,1)
	player.start_stop_movement(true,"Interaction")
	self.visible = false
	self.remove_from_group("Interactable")
	process_mode = Node.PROCESS_MODE_DISABLED
