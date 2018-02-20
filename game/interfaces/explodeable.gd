# interface extends parent with explode particles/animation, area of destruction
extends "res://game/interfaces/isable.gd"

export(String, "multible", "single", "smoke") var explosion_type
var collision_settings = []

func is_explodeable():
	if activated:
		return self
	else:
		return null

func _ready():
	collision_settings = global.collision_layer_masks["explosion"]


	call_deferred("initialize")

func initialize():
	if not is_explodeable():
		return

	if explosion_type and get_node(explosion_type):
		get_node(explosion_type + "/blastradius").collision_layer = collision_settings[0]
		get_node(explosion_type + "/blastradius").collision_mask = collision_settings[1]

	var destroy_able = interface.is_destroyable(parent)

	if destroy_able:
		destroy_able.connect("been_destroyed", self, "explode")
	else:
		print("somethings wrong")


func set_explosion_type(type):
	explosion_type = type

func explode(by_whom):
	print (explosion_type + "explosion...")

	if explosion_type and get_node(explosion_type):
		var explosion = get_node(explosion_type)
		remove_child(explosion)
		parent.get_parent().add_child(explosion)
		explosion.position = parent.position

		explosion.get_node("particles").emitting = 1
		explosion.get_node("particles").restart()
	else:
		print (explosion_type + "not found...")


#	var particles = get_node("explosion/Particles2D")

#	remove_child(particles)
#	parent.get_parent().add_child(particles)
#	particles.position = parent.position

	#particles.process_material.emission_sphere_radius = parent.width
#	particles.emitting = 1
#	particles.restart()

