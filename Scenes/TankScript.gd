extends Spatial

var dieParticle = preload("res://Scenes/ParticleScenes/TankDieParticle.tscn")
var redMat = preload("res://assets/Materials/RedMat.tres")
var BaseMat = preload("res://map/Material_010.material")
var target

var turnSpeed = 0.05
var enabled = true
var TankHealth = 3
var IAmTank = true

# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_parent().find_node("Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !enabled:
		return
	var newTarget = target.global_translation
	newTarget.y = global_translation.y
	$LookAt.look_at(newTarget,Vector3.UP)
	global_transform = global_transform.interpolate_with($LookAt.global_transform,turnSpeed)
	
	
	
	
func takeDamage(damage):
	TankHealth -= damage
	get_node("Cube").set_surface_material(0, redMat)
	print(TankHealth)
	if(TankHealth <= 0):
		Die()
		
	yield(get_tree().create_timer(0.25), "timeout")
	get_node("Cube").set_surface_material(0, BaseMat)
		
func Die():
	var particle = dieParticle.instance()
	get_parent().add_child(particle)
	particle.global_transform.origin = global_transform.origin + Vector3.UP * 2
	particle.emitting = true
	queue_free()
