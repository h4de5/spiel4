
extends Node

func collect_properties(node):
	var properties = {}
	if not node == null:
		if node.has_method("get_property"):
			properties = node.get_property(null)

		for child in node.get_children():
			if child.has_method("get_property"):
				merge_dicts(properties, child.get_property(null))
	return properties

static func merge_dicts(target, patch):
	for key in patch:
		target[key] = patch[key]
	return target

func is(node, interface):
	if interface == "adjustable":
		return is_adjustable(node)
	elif interface == "shootable":
		return is_shootable(node)
	elif interface == "moveable":
		return is_moveable(node)
	elif interface == "destroyable":
		return is_destroyable(node)

func is_adjustable(node, recursive= true):
	if node == null:
		return false
	if node.has_method("is_adjustable"):
		if node.is_adjustable():
			return node
	if recursive:
		for child in node.get_children():
			if is_adjustable(child, false) :
				return child
	return false

func is_shootable(node, recursive= true):
	if node == null:
		return false
	if node.has_method("is_shootable"):
		if node.is_shootable():
			return node
	if recursive:
		for child in node.get_children():
			if is_shootable(child, true) :
				return child
	return false

func is_moveable(node, recursive= true):
	if node == null:
		return false
	if node.has_method("is_moveable"):
		if node.is_moveable():
			return node
	if recursive:
		for child in node.get_children():
			if is_moveable(child, false) :
				return child
	return false

func is_destroyable(node, recursive= true):
	if node == null:
		return false
	if node.has_method("is_destroyable"):
		if node.is_destroyable():
			return node
	if recursive:
		for child in node.get_children():
			if is_destroyable(child, false) :
				return child
	return false

