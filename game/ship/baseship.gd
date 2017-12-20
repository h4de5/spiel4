extends RigidBody2D


var properties
# health bar
var health_obj

# call order:
# baseship._ready > player.init > baseship.init > player._ready

func _ready():
	print("im ready baseship - anfang")
	properties = {
		global.properties.movement_speed_forward: 800,
		global.properties.movement_speed_back: 400,
		global.properties.ship_rotation_speed: 0.5,
		global.properties.weapon_rotation_speed: 3.5,
		global.properties.clearance_rotation: 0.05,
		global.properties.zoom_speed: 0.2,
		global.properties.bullet_speed: 800,
		global.properties.bullet_strength: 50,
		global.properties.bullet_wait: 0.3,
		global.properties.bullet_range: 1000,
		global.properties.health_max: 1000,
		global.properties.health: 1000
	}
	
	initialize()
	print("im ready baseship - ende")

func initialize() :
	set_fixed_process(true)
	set_max_contacts_reported(4)
	
	set_mass(10)
	set_weight(10)
	set_friction(1)
	set_bounce(0.5)
	set_gravity_scale(0)
	set_linear_damp(2)
	set_angular_damp(4)
	
	set_max_contacts_reported(4)
	
	
	
	connect("body_enter", self, "processCollision")
	
	# Health bar
	var health_scn = load(global.scene_path_healthbar)
	var health_node = health_scn.instance()
	#get_parent().add_child(health_node)
	get_parent().call_deferred("add_child", health_node, true)
	health_node.set_owner(self)
	
	reset_position()
	
# called to reset a position, usually after initialize
func reset_position() :
	pass

# see https://github.com/godotengine/godot/issues/2314
# and . https://github.com/godotengine/godot/issues/8103
func fix_collision_shape():
	for shape in get_children():
		if not shape extends CollisionShape2D and not shape extends CollisionPolygon2D: 
			continue
		if shape.has_meta("__registered") and shape.get_meta("__registered"):
			continue
		
		get_tree().set_editor_hint(true)
		
		remove_child(shape) # Make it pick up the editor hint
		add_child(shape)
		
		get_tree().set_editor_hint(false) # Unset quickly
		
		if shape extends CollisionShape2D: # Now update parent is working, so just change the shape
			shape.set_shape(shape.get_shape())
		elif shape extends CollisionPolygon2D:
			shape.set_polygon(shape.get_polygon())
		
		remove_child(shape) # Reset its editor hint cache, just in case it was needed.. (you might drop this part if it bottlenecks)
		add_child(shape)
		
		shape.set_meta("__registered", true)


func handle_action(action, pressed):
	get_node("moveable").handle_action(action, pressed)
	
func handle_mousemove(pos) :
	get_node("moveable").handle_mousemove(pos)



func set_processor(processor):
	get_node("Processors").set_processor(processor)
	get_node("Processors").get_processor().set_parent(self)

func set_processor_details(device_details):
	get_node("Processors").get_processor().set_processor_details(device_details)

# get all different properties from this ship
func get_properties():
	return properties

func get_property(type):
	#if (properties.has_index(type)) :
	if (type in properties) :
		return properties[type]
	else :
		return null

func set_property(type, value):
	if (type in properties) :
		properties[type] = value

# empty implementation of shoot
func shoot(path): 
	
	#var shoot_scn = load("res://game/"+object+".tscn")
	var shoot_scn = load(path)
	var shoot_node = shoot_scn.instance()
	#get_tree().get_current_scene().add_child(shoot_scn)
	get_parent().add_child(shoot_node)
	shoot_node.set_owner(self)
	
	#shoot_wait = get_property(global.properties.bullet_wait)
	

func can_destroy():
	return true

func destroy(destroyer):
	print(self, "was destroyed by ", destroyer)
	get_node(global.scene_tree_ship_locator).free_ship(self)
	queue_free()

func hit(power, hitter):
	var health
	health = get_property(global.properties.health) - power
	set_property(global.properties.health, health)
	
	# update healthbar
	#health_obj.changeHealth(-power);
	
	if (health <= 0):
		destroy(hitter)
		#get_node("anim").play("explode")
		#destroyed=true


func processCollision(obstacle):
	
	if(obstacle.is_in_group('enemy') or obstacle.is_in_group('player')) :
		var obstacle_vel = obstacle.get_linear_velocity()
		var impact = get_linear_velocity().dot(obstacle_vel);
		#print("processCollision ", obstacle.get_name(), obstacle_vel, get_linear_velocity(), impact)
		#health_obj.changeHealth(-abs(impact) / 20000);
		
		#if health_obj.getHealth() <= 0: 
		#	get_tree().change_scene(global.scene_path_gameover)
		# process impact on obstacle
		obstacle.processCollision(impact)
		
		# now about where we hit it
		var player_pos = get_pos()
		var obstacle_pos = obstacle.get_pos()
		var hit_position = player_pos - obstacle_pos
		print("hitpos: ", player_pos.normalized())
		
		"""
		var raycast = RayCast(obstacle_pos)
		
		raycast.set_cast_to(player_pos)
		if raycast.is_colliding() : 
			print("get_collision_point: ", raycast.get_collision_point(), " get_collider: ", raycast.get_collider())
		"""