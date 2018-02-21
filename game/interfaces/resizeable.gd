extends "res://game/interfaces/isable.gd"

#export(float, 0.1, 20, 0.1) var body_scale = 1
#export(float, 0.1, 20, 0.1) var body_scale_base = 1

export(Vector2) var body_scale 
export(Vector2) var body_scale_base 

func is_resizeable():
	if activated:
		return self
	else:
		return null

func _ready():
	required_properties = [
		#global.properties.body_scale_max,
		#global.properties.body_scale_min
	]
	call_deferred("initialize")

func initialize():
	# Health bar
	if not is_resizeable():
		return
	body_scale = parent.get_scale()
	body_scale_base = parent.get_scale()

	if not parent.has_method('_integrate_forces'):
		print("Object " , parent, " is missing function _integrate_forces to enable ", self)
		activated = false
	else:
		resize_body_to(body_scale)


func _integrate_forces(state):
	#print("im _integrate_forces mit state: ", state, " current scale: ", get_property(global.properties.body_scale))
	#set_scale(parent.get_property(global.properties.body_scale))
	parent.set_scale(body_scale)

func reset_body():
	resize_body_to(body_scale_base)

func resize_body_to( new_scale ):
	resize_body( new_scale / body_scale )


# resizing objects includeing collision shape .. does not work well
func resize_body( factor ) :
	#print("count: ", parent.shape_owner_get_shape_count(0))
	# somehow works well in 2.1.4
	#for i in range(parent.get_shape_count()):
	for i in range(parent.shape_owner_get_shape_count(0)):
		 
		#var shape = parent.get_shape(i)
		var shape = parent.shape_owner_get_shape(0, i)
		var shape_new = null

		# first we only support circleshaps
		if shape is CircleShape2D:
			# create new shape instance
			shape_new = CircleShape2D.new()
			# get radius from current shape
			# add scale factor
			shape_new.set_radius(shape.get_radius() * factor.x)
		elif shape is CapsuleShape2D:
			shape_new = CapsuleShape2D.new()
			shape_new.set_radius(shape.get_radius() * factor.x)
			shape_new.set_height(shape.get_height() * factor.y)
		elif shape is RectangleShape2D:
			shape_new = RectangleShape2D.new()
			shape_new.set_extents(shape.get_extents() * factor)
		elif shape is ConcavePolygonShape2D:
			shape_new = ConcavePolygonShape2D.new()
			var segments = shape.get_segments()
			var segments_new = []
			for segment in segments:
				segments_new.append(segment*factor)
			shape_new.set_segments(segments_new)
		elif shape is ConvexPolygonShape2D:
			shape_new = ConvexPolygonShape2D.new()

			var points = shape.get_points()
			var points_new = []
			for point in points:
				points_new.append(point*factor)
			shape_new.set_points(points_new)

		if shape_new != null:
			shape_new.set_custom_solver_bias(shape.get_custom_solver_bias())
			# get transformation from current shape
			#var shape_transform = parent.get_shape_transform(i)
			var shape_transform = parent.shape_owner_get_transform(0)
			
			# remove current shape
			#parent.remove_shape(i)
			parent.shape_owner_remove_shape(0, i)
			# add new shape with transformation
			#parent.add_shape(shape_new, shape_transform)
			parent.shape_owner_add_shape(0, shape_new)
			parent.shape_owner_set_transform(0, shape_transform)

	# works fine for centered shapes
	# but does not go recursive through all sprites
#	for shape in get_children():
#		if (not shape extends Sprite):
#			continue
#		shape.set_scale(shape.get_scale()*scale)

	# will be reset immidieatly
	# see bug https://github.com/godotengine/godot/issues/5734
	#set_scale(get_scale() * scale)
	# will only resize sprite, but not collision
	#var current_scale = parent.get_property(global.properties.body_scale)

	var current_scale = body_scale
	current_scale *= factor

	var scale_max = parent.get_property(global.properties.body_scale_max)
	if scale_max != null and current_scale > scale_max :
		current_scale = scale_max

	var scale_min = parent.get_property(global.properties.body_scale_min)
	if scale_min != null and current_scale < scale_min :
		current_scale = scale_min

	#parent.set_property(global.properties.body_scale, current_scale)
	body_scale = current_scale

#

