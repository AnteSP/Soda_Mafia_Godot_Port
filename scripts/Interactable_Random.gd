extends Interactable

class_name Interactable_Random
@export var item_pool: Array[InvItem]  

func Use(_inp):
	if item_pool:
		Stats.current.inventory.add_item(item_pool.pick_random(),1)
	if use_time != 0:
		$AnimatedSprite2D.play("default")
		player.current.sbp.progress_bar.reset_timer()
		player.current.sbp.reset_spacebar()
