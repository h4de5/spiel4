# standard bullet class used in cannon weapon and by shootable
extends RigidBody2D

# owner/shooter of the bullet
var parent
# properties of the owner
var properties = null
var starting_pos = null

func _ready():
	set_fixed_process(true)
	initialize()

func initialize():
	# add to group bullet
	add_to_group(global.groups.bullet)
	connect("body_enter", self, "processCollision")

func set_parent(p) :
	parent = p
	add_collision_exception_with(parent)

	var shootable = interface.is_shootable(parent)
	if shootable:
		properties = shootable.get_property(null)


		#bullet.set_pos(get_node("muzzle").get_global_pos())

		#starting_pos = parent.get_node("weapon").get_global_pos()
		#set_pos(starting_pos)
		#var starting_rot = (parent.get_node("weapon").get_global_rot()) + PI
		#set_rot(starting_rot + PI)


		var starting_rot = get_global_rot()

		var v2 = Vector2(  sin(starting_rot), cos(starting_rot)   ).normalized()
		set_linear_velocity(v2 * properties[global.properties.bullet_speed]);


func _fixed_process(delta):
	if properties != null and starting_pos != null:
		if(get_pos().distance_to(starting_pos) > properties[global.properties.bullet_range]) :
			destroy("range_over")

func processCollision( object ):
	#print ("body enter bullet")
	#print(object)
	var destroyable = interface.is_destroyable(object)
	if destroyable:
		destroyable.hit(properties[global.properties.bullet_strength], parent)
	# kill yourself
	destroy(self)
	"""
	if (object.has_method("hit") and
		object.has_method("is_destroyable") and
		object.is_destroyable()) :
		object.hit(properties[global.properties.bullet_strength], owner)
		destroy(self)
	"""


func _on_visibility_exit_screen():
	#print ("out of screen bullet")
	destroy("range_out")

func destroy(destroyer) :
	# TODO add cool animation -
	queue_free()
