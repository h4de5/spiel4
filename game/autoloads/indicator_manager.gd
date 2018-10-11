extends Control

var indicator = preload("res://game/gui/indicator.tscn")

var camera = null
var trackables = {}

func _ready():
	pass

func register_camera(cam):
	camera = cam

func register_trackable(trackable):

	var indi = indicator.instance()
	add_child(indi)
	trackables[trackable] = indi

func unregister_trackable(trackable):
	trackables[trackable].queue_free()
	trackables.erase(trackable)

func _process(delta):
	if trackables != null and trackables.size() > 0:
		for trackable in trackables:

			var pos = trackable.global_position

			var current_viewport
			# static camera
			current_viewport = get_viewport_rect()
			print("current_viewport control: ", current_viewport)
			# moveable camera
			var camera = get_node(global.scene_tree_camera)
			current_viewport = camera.get_viewport().get_visible_rect()
			print("current_viewport camera : ", current_viewport)


			var rect = current_viewport
			rect.position -= current_viewport.size * 0.5

			if rect.has_point(pos):
				trackables[trackable].hide()
			else:

				print("original pos: ", pos)

				pos = get_viewport_transform().xform(pos)
				#pos = get_viewport_transform().affine_inverse()
				#pos = camera.get_viewport().get_final_transform().xform(pos)

				# FIXME - this does not work with camera

				print("transform pos: ", pos)

				pos.x = clamp(pos.x, 0, current_viewport.size.x) - current_viewport.size.x * 0.5
				pos.y = clamp(pos.y, 0, current_viewport.size.y) - current_viewport.size.y * 0.5

				# TODO maybe use camera transform instead of viewport?
				trackables[trackable].rect_position = pos
				trackables[trackable].rect_rotation = rad2deg(atan2(pos.y, pos.x))
				trackables[trackable].show()


