# global autoload with functions to check if a node has an interface
extends Node

# goes through node and collects all get_property functions
# properties .. can be set and overwritten
# properties_modifier_add .. points will be added or reduced from normal properties
# properties_modifier_multi .. points will be multiplied or divided after modifier_add

func collect_properties(node, properties = {}, level = 0):
	if not node == null:
		if node.has_method("get_property"):
			properties = node.get_property(null)

		properties.erase(global.properties.modifier_add)
		properties.erase(global.properties.modifier_multi)

		for child in node.get_children():
			if child.has_method("get_property"):
				merge_dicts(properties, child.get_property(null))
			else:
				properties = collect_properties(child, properties, level+1)
	if level == 0:
		if properties.has(global.properties.modifier_add) :
			for key in properties[global.properties.modifier_add]:
				if properties.has(key):
					properties[key] += properties[global.properties.modifier_add][key]
				else :
					properties[key] = properties[global.properties.modifier_add][key]

		if properties.has(global.properties.modifier_multi) :
			for key in properties[global.properties.modifier_multi]:
				if properties.has(key):
					properties[key] *= properties[global.properties.modifier_multi][key]

	return properties

static func merge_dicts(target, patch):
	for key in patch:
		if target.has(key) and typeof(patch[key]) == TYPE_DICTIONARY:
			target[key] = merge_dics(target[key], patch[key])
		else:
			target[key] = patch[key]

	return target

# check if node has interface
# can be shootable, adjustable, destroyable,
func is_able(node, interface, recursive= true):
	if node == null:
		return null
	if interface == null or interface == "":
		return null

	# must have method and be an extendent to isable
	if (node extends load("res://game/interfaces/isable.gd") and
		node.has_method("is_"+interface)):
		return node.call("is_"+interface)

	# only go down one level
	if recursive:
		# for each child in node
		for child in node.get_children():
			# if has interface method, return result
			if (child extends load("res://game/interfaces/isable.gd") and
				child.has_method("is_"+interface)):
				return child.call("is_"+ interface)
			else :
				# if not, go one level deeper
				var isable = is_able(child, interface, false)
				if isable:
					return isable
	return null

func is_shootable(node, recursive= true):
	return is_able(node, "shootable", recursive)

func is_moveable(node, recursive= true):
	return is_able(node, "moveable", recursive)

func is_destroyable(node, recursive= true):
	return is_able(node, "destroyable", recursive)

func is_collectable(node, recursive= true):
	return is_able(node, "collectable", recursive)

# for later

func is_adjustable(node, recursive= true):
	return is_able(node, "adjustable", recursive)

func is_collidable(node, recursive= true):
	return is_able(node, "collidable", recursive)

func is_explodeable(node, recursive= true):
	return is_able(node, "explodeable", recursive)