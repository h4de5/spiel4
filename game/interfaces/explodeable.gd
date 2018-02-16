# interface extends parent with explode particles/animation, area of destruction
extends "res://game/interfaces/isable.gd"

var collision_settings = []
func is_explodeable():
	if activated:
		return self
	else:
		return null

func _ready():
	collision_settings = global.collision_layer_masks["explosion"]

	get_node("explosion/blastradius").collision_layer = collision_settings[0]
	get_node("explosion/blastradius").collision_mask = collision_settings[1]
	call_deferred("initialize")

func initialize():
	if not is_explodeable():
		return

	var destroy_able = interface.is_destroyable(parent)

	if destroy_able:
		destroy_able.connect("been_destroyed", self, "explode")
	else:
		print("somethings wrong")

func explode(by_whom):
	print ("exploding...")
	var explosion = get_node("explosion")
	remove_child(explosion)
	parent.get_parent().add_child(explosion)
	explosion.position = parent.position

	explosion.get_node("Particles2D").emitting = 1
	explosion.get_node("Particles2D").restart()


#	var particles = get_node("explosion/Particles2D")

#	remove_child(particles)
#	parent.get_parent().add_child(particles)
#	particles.position = parent.position

	#particles.process_material.emission_sphere_radius = parent.width
#	particles.emitting = 1
#	particles.restart()

