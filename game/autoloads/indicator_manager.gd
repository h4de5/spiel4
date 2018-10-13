extends Control

var indicator = preload("res://game/gui/indicator.tscn")

var camera = null
var trackables = {}
var updates = 0
var camera_node = null

func _ready():
	pass
	#camera = get_node(global.scene_tree_camera)

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
# func _physics_process(delta):

	if camera == null:
		camera = get_node(global.scene_tree_camera)

	updates = updates + delta + 1
	if updates > 0.05:
		updates = 0

		var camera_rect
		var camera_rect_zoomed
		var camera_pos
		var transform = get_viewport_transform()

		#var camera = get_node(global.scene_tree_camera)
		camera_rect = camera.get_viewport().get_visible_rect()

		#print("camera_rect_orig: ", camera_rect)
		#print("camera.zoom: ", camera.zoom)
		# print("camera offset: ", camera.offset, camera.offset_v, camera.offset_h)

		#camera_pos = camera.get_camera_position()
		camera_pos = camera.get_camera_screen_center()
		#print("camera_pos: ", camera_pos, " vs position: ", camera.position, " screen center: ", camera.get_camera_screen_center())

		camera_rect.size *= camera.zoom
		camera_rect_zoomed = camera_rect

		# AAJAHAHAHAHAHAHHAHA DAS WARS !!
		transform = transform.scaled(camera.zoom)
		#print("camera_rect_zoomed: ", camera_rect_zoomed)

		# move it half - keep size
		# rect.position -= rect.size * 0.5
		camera_rect.position -= camera_rect_zoomed.size * 0.5
		camera_rect.position += camera_pos

		# print("modified rect: ", rect)
		#print("modified camera_rect: ", camera_rect)

		for trackable in trackables:
			var pos = trackable.position

			if camera_rect.has_point(pos):
				trackables[trackable].hide()
			else:
				pos = transform.xform(pos)

				pos.x = clamp(pos.x, 0, camera_rect_zoomed.size.x) - camera_rect_zoomed.size.x * 0.5 + camera_pos.x
				pos.y = clamp(pos.y, 0, camera_rect_zoomed.size.y) - camera_rect_zoomed.size.y * 0.5 + camera_pos.y

				# DONE maybe use camera transform instead of viewport?
				trackables[trackable].rect_position = pos
				trackables[trackable].rect_rotation = rad2deg(atan2(pos.y - camera_pos.y, pos.x - camera_pos.x))
				trackables[trackable].show()
