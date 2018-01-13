extends Area2D

var properties_base = {
		# weapon, modifier, passenger, goods, bomb
		global.properties.pickup_type: 1,
		# pickup lasts seconds
		global.properties.pickup_duration: 30,
		 # set, add, multiply
		global.properties.pickup_modifier_mode: 2,
		# modifier lasts seconds
		global.properties.pickup_modifier_duration: 10,

		global.properties.modifier_multi: {
			global.properties.movement_speed_forward: 4,
			global.properties.ship_rotation_speed: 4,
		}
	}
var collectable = null

func _ready():
	#set_fixed_process(true)
	call_deferred("initialize")

func initialize():
	collectable = interface.is_collectable(self)

func set_randompos():

	randomize();
	var box = get_node(global.scene_tree_ship_locator).get_bounding_box_all([self])
	if box != null :
		box = box.pos + box.size/2
	else :
		box = Vector2(0,0)
	var angle = rand_range(0, 2*PI)
	set_pos( box +  (Vector2(sin(angle), cos(angle)) * 1000) )

func collected(reason):
	# free is called in collectable
	# spawn another pickup
	get_node(global.scene_tree_game).spawn_pickup()


