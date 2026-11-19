class_name Rec_UI extends Control

@export var RecipeButton: TextureButton
@onready var inv: Inv = preload("res://Prefabs/Items/PlayerInventory.tres")
@onready var slots: Array[Node] = $NinePatchRect/GridContainer.get_children()

@onready var title: RichTextLabel = $Title
@onready var desc: RichTextLabel = $Description

var is_open = false

func _ready():
	print("DOING READY")
	update_slots()
	close()

func update_slots():
	for i in slots:
		print("GOT HERE 1")
		if i is Rec_ui_slot:#LATER MAKE THIS CHECK IF RECIPE IS SAVED
			print("GOT HERE 2")
			i.update(self)

func display_info_for(item: InvItem) -> void:
	if !item:
		title.text = ""
		desc.text = "..."
	else:
		title.text = item.name
		desc.text = item.desc

func _on_visibility_changed() -> void:
	if inv:
		update_slots()

#func _process(_delta: float) -> void:
#	if Input.is_action_just_pressed("e"):
#		if is_open:
#			close()
#		else:
#			open()

func open():
	visible = true
	is_open = true

func close():
	visible = false
	is_open = false
