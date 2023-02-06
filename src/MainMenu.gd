extends Spatial

var shader_resource = preload("res://assets/shader/ZoneShader.tres")

func vec_to_color(vec: Vector3) -> Color:
	return Color(vec.x, vec.y, vec.z)

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if shader_resource.get_shader_param("active_points") > 0:
		return
	show_one()
	
	Engine.target_fps = 60

func show_one():
	$TowerRedModel.activate()
	
	var point_img_data = Image.new()
	point_img_data.create(100, 1, false, Image.FORMAT_RGBAF)
	point_img_data.fill(Color.black)
	
	point_img_data.lock()
	point_img_data.set_pixel(0, 0, vec_to_color($TowerRedModel.global_translation * 2))
	point_img_data.unlock()
	
	var radius_img_data = Image.new()
	radius_img_data.create(100, 1, false, Image.FORMAT_RGBAF)
	radius_img_data.fill(Color.black)
	
	radius_img_data.lock()
	radius_img_data.set_pixel(0, 0, Color(190.0 * 2, 0, 0))
	radius_img_data.unlock()
	
	var tex = ImageTexture.new()
	tex.create_from_image(point_img_data)
	shader_resource.set_shader_param("center_points", tex)
	
	var tex2 = ImageTexture.new()
	tex2.create_from_image(radius_img_data)
	shader_resource.set_shader_param("radiuses", tex2)
	
	shader_resource.set_shader_param("active_points", 1)
