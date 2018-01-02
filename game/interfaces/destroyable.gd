# interface extends parent with healthbar, hit and destroy methods
extends "res://game/interfaces/isable.gd"

var health_node = null

func is_destroyable():
	if activated:
		return self
	else:
		return null

func _ready():
	#print("destroyable _ready - start ", get_parent().get_name(), " activated: ", activated)

	required_properties = [
		global.properties.health,
		global.properties.health_max
	]

	call_deferred("initialize")

	#print("destroyable _ready - end ", get_parent().get_name(), " activated: ", activated)


func initialize():
	# Health bar
	if not is_destroyable():
		return

	var health_scn = load(global.scene_path_healthbar)
	health_node = health_scn.instance()
	parent.get_parent().add_child(health_node)
	#parent.get_parent().call_deferred("add_child", health_node, true)
	health_node.set_owner(parent)

func destroy(destroyer):
	# health_node is destroying itself
	#if health_node != null:
	#	health_node.queue_free()
	pass

func hit(power, hitter):
	var health
	health = parent.get_property(global.properties.health) - power
	parent.set_property(global.properties.health, health)

	if (health <= 0):
		parent.destroy(hitter)
		#get_node("anim").play("explode")
		#destroyed=true