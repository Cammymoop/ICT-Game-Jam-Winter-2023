extends Spatial

signal activated
signal deactivated

var activated: = false
var growth_timer = 0.0
var time_to_grow = 7.0
var growing: = false

onready var vine_shader : ShaderMaterial = find_node("VineModel").mesh.surface_get_material(0)

func _ready():
	if vine_shader:
		vine_shader.set_shader_param("progress", 0.0)

func start_growth() -> void:
	growing = true

func _process(delta):
	if growing:
		growth_timer += delta
		if growth_timer >= time_to_grow:
			growing = false
			activate()
			
			vine_shader.set_shader_param("progress", 2.0)
		
		vine_shader.set_shader_param("progress", growth_timer/time_to_grow)


func activate() -> void:
	emit_signal("activated", self)


func _on_FruitDetector_body_entered(body):
	if body.name == "Player" and body.has_fruit:
		body.drop_seed()
		
		start_growth()
