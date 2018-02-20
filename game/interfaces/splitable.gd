# interface to make a node split on beeing destroy
extends "res://game/interfaces/isable.gd"

export(PackedScene) var left_part
export(PackedScene) var right_part

func is_splitable():
	if activated:
		return self
	else:
		return null

func _ready():
	call_deferred("initialize")

func initialize():

	if not is_splitable():
		return

	var destroyable = interface.is_destroyable(parent)
	if destroyable :
		destroyable.connect("been_destroyed", self, "_on_been_destroyed")


func _on_been_destroyed(by_whom):
	if left_part != null:
		var part = left_part.instance()
		get_tree().current_scene.add_child(part)
		part.position = parent.position

	if right_part != null:
		var part = right_part.instance()
		get_tree().current_scene.add_child(part)
		part.position = parent.position