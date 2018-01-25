extends "res://game/interfaces/isable.gd"

var body_scale
var body_scale_base

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
		print_error("function", "_integrate_forces")
		activated = false


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
	# somehow works well
	for i in range(parent.get_shape_count()):
		var shape = parent.get_shape(i)
		var shape_new = null

		# first we only support circleshaps
		if shape extends CircleShape2D:
			# create new shape instance
			shape_new = CircleShape2D.new()
			# get radius from current shape
			# add scale factor
			shape_new.set_radius(shape.get_radius() * factor)
		elif shape extends CapsuleShape2D:
			shape_new = CapsuleShape2D.new()
			shape_new.set_radius(shape.get_radius() * factor)
			shape_new.set_height(shape.get_height() * factor)
		elif shape extends RectangleShape2D:
			shape_new = RectangleShape2D.new()
			shape_new.set_extents(shape.get_extents() * factor)
		elif shape extends ConcavePolygonShape2D:
			shape_new = ConcavePolygonShape2D.new()
			var segments = shape.get_segments()
			var segments_new = []
			for segment in segments:
				segments_new.append(segment*factor)
			shape_new.set_segments(segments_new)
		elif shape extends ConvexPolygonShape2D:
			shape_new = ConvexPolygonShape2D.new()

			var points = shape.get_points()
			var points_new = []
			for point in points:
				points_new.append(point*factor)
			shape_new.set_points(points_new)

		if shape_new != null:
			shape_new.set_custom_solver_bias(shape.get_custom_solver_bias())
			# get transformation from current shape
			var shape_transform = parent.get_shape_transform(i)
			# remove current shape
			parent.remove_shape(i)
			# add new shape with transformation
			parent.add_shape(shape_new, shape_transform)

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

