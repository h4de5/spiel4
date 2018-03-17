# interface extends parent with explode particles/animation, area of destruction
extends "res://game/interfaces/isable.gd"

export(String, "multiple", "single", "smoke") var explosion_type
var explosion_nodes = {}
# collision layer and mask bits
var collision_settings = []

func is_explodeable():
	if activated:
		return self
	else:
		return null

func _ready():
	collision_settings = global.collision_layer_masks["explosion"]

	explosion_nodes["multiple"] = get_node("multiple")
	explosion_nodes["single"] = get_node("single")
	explosion_nodes["smoke"] = get_node("smoke")

	call_deferred("initialize")

func initialize():
	if not is_explodeable():
		return
		
	var destroy_able = interface.is_destroyable(parent)
	if destroy_able:
		destroy_able.connect("been_destroyed", self, "explode")
	else:
		print("Parent ", parent, " of explodeable ", self, " is not destroyable - this is not right")
		return
	
	if explosion_type:
		set_explosion_type(explosion_type)
	else:
		remove_explosions()

	
# remove all explosion nodes
func remove_explosions():
	for explosion_node in explosion_nodes:
		# remove all other explosion types
		if has_node(explosion_node):
			remove_child(explosion_nodes[explosion_node])

func set_explosion_type(type):
	explosion_type = type
	
	remove_explosions()
	
	if explosion_type:
		
		# add only correct explosion type
		add_child(explosion_nodes[explosion_type])
		
		# set collision options correctly
		get_node(explosion_type + "/blastradius").collision_layer = collision_settings[0]
		get_node(explosion_type + "/blastradius").collision_mask = collision_settings[1]
		
		# hide collision at start
		get_node(explosion_type + "/blastradius/collision").disabled = true
		get_node(explosion_type + "/blastradius/collision").visible = false
		

func explode(by_whom):
	print (explosion_type + "explosion...")

	if explosion_type and get_node(explosion_type):
		var explosion = get_node(explosion_type)
		# move explosion to parent node
		remove_child(explosion)
		parent.get_parent().add_child(explosion)
		explosion.position = parent.position

		# start explosion
		explosion.get_node("particles").emitting = 1
		explosion.get_node("particles").restart()
		
		# start timer to finally remove explodable from scene
		var timer = get_node("Timer")
		timer.one_shot = 1
		timer.wait_time = explosion.get_node("particles").lifetime / explosion.get_node("particles").speed_scale
		timer.start()
		print("timer started for ", timer.wait_time, " seconds.")
		
	else:
		print (explosion_type + "not found...")


#	var particles = get_node("explosion/Particles2D")

#	remove_child(particles)
#	parent.get_parent().add_child(particles)
#	particles.position = parent.position

	#particles.process_material.emission_sphere_radius = parent.width
#	particles.emitting = 1
#	particles.restart()



func _on_Timer_timeout():
	# remove explodeable node
	print("Remove explosion node")
	queue_free()
