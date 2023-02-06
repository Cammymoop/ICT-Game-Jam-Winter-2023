extends Spatial

signal activated
signal deactivated
var activated: = false
var growth_timer = 0.0
var time_to_grow = 7.0
var growing: = false
var i_am_tower: = true

var health = 12.0
var max_health: float

var redMat = preload("res://assets/Materials/RedMat.tres")
var greenMat = preload("res://assets/Materials/GreenMat.tres")
var vine_mat

var inactive_mat = preload("res://assets/Models/Material_009.material")
var active_mat = preload("res://assets/good_tower_mat.tres")

onready var vine_shader : ShaderMaterial = find_node("VineModel").mesh.surface_get_material(0)

func _ready():
	max_health = health
	
	if vine_shader:
		vine_shader.set_shader_param("progress", 0.0)
	
	vine_mat = $VinesForTower/VineModel.mesh.surface_get_material(0)

func heal(amt: float) -> void:
	if not activated:
		return
	if health >= max_health:
		return
	flash_green()
	health = min(max_health, health + amt)

func take_damage(amt: float) -> void:
	if not activated and growing:
		flash_red()
		growing = false
		growth_timer = 0.0
		yield(get_tree().create_timer(0.25), "timeout")
		vine_shader.set_shader_param("progress", 0.0)
		return
	elif not activated:
		return
	
	flash_red()
	health -= amt
	if health <= 0:
		health = max_health
		deactivate() 

func start_growth() -> void:
	growing = true

func _process(delta):
	if growing:
		growth_timer += delta
		if growth_timer >= time_to_grow:
			growing = false
			activate()
		
		vine_shader.set_shader_param("progress", growth_timer/time_to_grow)


func activate() -> void:
	activated = true
	emit_signal("activated", self)
	
	vine_shader.set_shader_param("progress", 2.0)
	
	$Cylinder005.mesh.surface_set_material(0, active_mat)
	$Area/CollisionShape.disabled = false

func deactivate() -> void:
	activated = false
	growth_timer = 0.0
	emit_signal("deactivated", self)
	
	vine_shader.set_shader_param("progress", 0.0)
	$Cylinder005.mesh.surface_set_material(0, inactive_mat)
	$Area/CollisionShape.disabled = true


		
func flash_green():
	
	$VinesForTower/VineModel.set_surface_material(0, greenMat)
	yield(get_tree().create_timer(0.25), "timeout")
	$VinesForTower/VineModel.set_surface_material(0, vine_mat)
	
func flash_red():
	
	$VinesForTower/VineModel.set_surface_material(0, redMat)
	yield(get_tree().create_timer(0.25), "timeout")
	$VinesForTower/VineModel.set_surface_material(0, vine_mat)


func _on_FruitDetector_body_entered(body):
	if growing or activated:
		return
	if body.name == "Player" and body.has_fruit:
		body.drop_seed()
		
		start_growth()
