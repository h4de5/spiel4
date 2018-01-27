# standard bullet class used in cannon weapon and by shootable
# calls hit() of destroyable interface
extends RigidBody2D

# owner/shooter of the bullet
var parent
# properties of the owner
var properties_snapshot = null
var starting_pos = null
var shootable = null

func _ready():
	set_fixed_process(true)
	initialize()

func initialize():
	# add to group bullet
	add_to_group(global.groups.bullet)
	connect("body_enter", self, "process_collision")

	# NOT IN USE
	# will be removed after bullet_range
	#get_node("visibility").connect("exit_screen", self, "_on_visibility_exit_screen")

func set_parent(p) :
	parent = p
	add_collision_exception_with(parent)

	get_node("Light2D").show()

	shootable = interface.is_shootable(parent)
	if not shootable:
		print("Error - Parent of bullet is not shootable: ", parent)
	else:
		# get properties from parent
		properties_snapshot = parent.get_property(null)

	starting_pos = parent.get_global_pos()

func _fixed_process(delta):
	if starting_pos != null:
		if(get_pos().distance_to(starting_pos) > properties_snapshot[global.properties.bullet_range]) :
			destroy("range_over")

func process_collision( object ):
	#print ("body enter bullet")
	#print(object)
	var destroyable = interface.is_destroyable(object)
	if destroyable:
		destroyable.hit(properties_snapshot[global.properties.bullet_strength], parent)
	# kill yourself (object is the "killer")
	destroy(object)

func _on_visibility_exit_screen():
	#print ("out of screen bullet")
	destroy("range_out")

func destroy(destroyer) :
	# TODO add cool animation -
	queue_free()
