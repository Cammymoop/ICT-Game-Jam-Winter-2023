extends Node

var shader_resource = preload("res://assets/shader/ZoneShader.tres")

var point_img_data : Image
var points : Array = []

var radius_img_data : Image

export(float, 1.2, 2.4, 0.05) var point_factor = 1.8

export var debug_points = PoolVector3Array()
export var enable_debugs = false

var dirty: = false

var target_radius = 190.0
var tween_time = 0.8

func vec_to_color(vec: Vector3) -> Color:
	return Color(vec.x, vec.y, vec.z)

func _ready():
	point_img_data = Image.new()
	point_img_data.create(100, 1, false, Image.FORMAT_RGBAF)
	point_img_data.fill(Color.black)
	
	radius_img_data = Image.new()
	radius_img_data.create(100, 1, false, Image.FORMAT_RGBAF)
	radius_img_data.fill(Color.black)

#func _process(_delta):
#	if Input.is_action_just_pressed("test_btn"):
#		print("boop")
#		var pos = Vector3.ZERO
#		pos.x += 12 * len(points)
#		add_point({"enabled": true, "position": pos})

func _process(_delta):
	if dirty:
		_update_points()

func add_point(point_info : Dictionary) -> void:
	point_info.color = vec_to_color(point_info.position * point_factor)
	point_info.radius = 0.0
	points.append(point_info)
	
	_update_points()
	
func do_tween(point_info) -> void:
	point_info.radius = 1.0
	var tw = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tw.tween_method(self, "tw_radius", 1.0, target_radius, 0.8, [point_info])

func tw_radius(value, point_info : Dictionary) -> void:
	#print(value)
	point_info.radius = value
	dirty = true

func update_points() -> void:
	dirty = true

func _update_points() -> void:
	var enabled_points = []
	
	for p in points:
		if p.enabled:
			if p.radius == 0.0:
				do_tween(p)
			enabled_points.append(p)
		else:
			p.radius = 0.0
	
	point_img_data.lock()
	radius_img_data.lock()
	
	var x = 0
	for ep in enabled_points:
		point_img_data.set_pixel(x * 2, 0, ep.color)
		radius_img_data.set_pixel(x * 2, 0, Color(ep.radius * 2, 0, 0))
		print(ep.radius)
		x += 1
		if x >= 100:
			break
	
	point_img_data.unlock()
	radius_img_data.unlock()
	
#	var img_tex : ImageTexture = shader_resource.get_shader_param("center_points")
#	if img_tex:
#		img_tex.set_data(point_img_data)
	var tex = ImageTexture.new()
	tex.create_from_image(point_img_data)
	shader_resource.set_shader_param("center_points", tex)
	
	var tex2 = ImageTexture.new()
	tex2.create_from_image(radius_img_data)
	shader_resource.set_shader_param("radiuses", tex2)
	
	shader_resource.set_shader_param("active_points", len(enabled_points) * 2)
	
	dirty = false
