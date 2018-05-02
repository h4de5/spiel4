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
	print("starting ", explosion_type, " explosion")

	if explosion_type and get_node(explosion_type):
#		var explosion = get_node(explosion_type)
#		# move explosion to parent node
#		remove_child(explosion)
#
#		explosion.name = explosion_type + " explosion of " + get_parent().name
#		parent.get_parent().add_child(explosion)
#		explosion.position = parent.position

		var explodeable = self
		get_parent().remove_child(explodeable)
		parent.get_parent().add_child(explodeable)
		explodeable.position = parent.position
		explodeable.name = explosion_type + " explosion of " + get_parent().name
		var explosion = explodeable.get_node(explosion_type)
		
		# start explosion
		explosion.get_node("particles").emitting = 1
		explosion.get_node("particles").restart()
		
		# aktivate collision
		explosion.get_node("blastradius/collision").disabled = false
		explosion.get_node("blastradius/collision").visible = true
				
		# start timer to finally remove explodable from scene
		var timer = get_node("Timer")
		if timer:
		# move timer to separate explosion
			remove_child(timer)
			explosion.add_child(timer)
			timer.one_shot = 1
			timer.wait_time = explosion.get_node("particles").lifetime / explosion.get_node("particles").speed_scale
			timer.connect("timeout", self, "_on_Timer_timeout")
			timer.start()
			print("timer started for ", timer.wait_time, " seconds.")
		else:
			print("error - no timer in explosion", self)
			
		
	else:
		print (explosion_type + "not found...")


#	var particles = get_node("explosion/Particles2D")

#	remove_child(particles)
#	parent.get_parent().add_child(particles)
#	particles.position = parent.position

	#particles.process_material.emission_sphere_radius = parent.width
#	particles.emitting = 1
#	particles.restart()

func _physics_process(delta):
	pass

func _collision_process(obstacle):
	print("obstacle in explosion: ", obstacle)
	
	if(obstacle.is_in_group(global.groups.npc) or 
		obstacle.is_in_group(global.groups.player) or 
		obstacle.is_in_group(global.groups.obstacle)) :
		print("obstacle in explosion: ", obstacle, " name: ", obstacle.name)
		if obstacle == parent:
			print("skipping parent..")
		else:
			var target_vec = obstacle.position - self.position
			
			var rect = self.get_viewport_rect()
			var maxpower = rect.size.x
			
			var hitpower = maxpower - self.position.distance_to(obstacle.position)
			hitpower = hitpower / 500
			
			obstacle.apply_impulse(Vector2(0,0), target_vec * hitpower)
			var destroyable = interface.is_destroyable(obstacle)
			if destroyable:
				destroyable.hit(hitpower * 100, parent )
			
func _on_Timer_timeout():
	# remove explodeable node
	print("Remove explosion node ", self)
	queue_free()
