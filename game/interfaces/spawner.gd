extends Node

onready var asteroid = get_parent()
onready var destroyable = asteroid.get_node("destroyable")

export(PackedScene) var left_part
export(PackedScene) var right_part

func _ready():
	destroyable.connect("been_destroyed", self, "_on_been_destroyed")

func _on_been_destroyed(by_whom):
	if left_part != null:
		var part = left_part.instance()
		get_tree().current_scene.add_child(part)
		part.position = asteroid.position

	if right_part != null:
		var part = right_part.instance()
		get_tree().current_scene.add_child(part)
		part.position = asteroid.position