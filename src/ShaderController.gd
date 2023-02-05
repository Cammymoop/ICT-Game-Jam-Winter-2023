extends Node

var shader_resource = preload("res://assets/shader/ZoneShader.tres")

var point_img_data : Image
var points : Array = []

func vec_to_color(vec: Vector3) -> Color:
	return Color(vec.x, vec.y, vec.z)

func _ready():
	point_img_data = Image.new()
	point_img_data.create(100, 1, false, Image.FORMAT_RGBAF)
	point_img_data.fill(Color.black)

#func _process(_delta):
#	if Input.is_action_just_pressed("test_btn"):
#		print("boop")
#		var pos = Vector3.ZERO
#		pos.x += 12 * len(points)
#		add_point({"enabled": true, "position": pos})

func add_point(point_info : Dictionary) -> void:
	point_info.color = vec_to_color(point_info.position)
	points.append(point_info)
	
	update_points()

func update_points() -> void:
	var enabled_points = []
	
	for p in points:
		if p.enabled:
			enabled_points.append(p)
	
	point_img_data.lock()
	
	var x = 0
	for ep in enabled_points:
		point_img_data.set_pixel(x, 0, ep.color)
		x += 1
		if x >= 100:
			break
	
	point_img_data.unlock()
	
#	var img_tex : ImageTexture = shader_resource.get_shader_param("center_points")
#	if img_tex:
#		img_tex.set_data(point_img_data)
	var tex = ImageTexture.new()
	tex.create_from_image(point_img_data)
	shader_resource.set_shader_param("center_points", tex)
	
	shader_resource.set_shader_param("active_points", len(enabled_points))
