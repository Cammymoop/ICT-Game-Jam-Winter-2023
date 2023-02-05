extends Spatial

var shootParticle = preload("res://TankParticleShoot.tscn")
var dieParticle = preload("res://Scenes/ParticleScenes/TankDieParticle.tscn")
var redMat = preload("res://assets/Materials/RedMat.tres")
var BaseMat = preload("res://assets/Models/Material_010.material")

var target

var turnSpeed = 0.05
var isLooking = true
var enabled = true
var TankHealth = 3
var IAmTank = true
var timeWhenLastFired = 0
var FireCooldown = 2000

# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_parent().find_node("Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !enabled:
		return
	if isLooking:
		var newTarget = target.global_translation
		newTarget.y = global_translation.y
		$LookAt.look_at(newTarget,Vector3.UP)
		global_transform = global_transform.interpolate_with($LookAt.global_transform,turnSpeed)
	
	var in_range = $Area.get_overlapping_bodies()
	
	for body in in_range:
		if body == $KinematicBody:
			continue
		if timeWhenLastFired + FireCooldown < Time.get_ticks_msec():
			Fire()
		
	
	
func Fire():
	timeWhenLastFired = Time.get_ticks_msec()
	var particle = shootParticle.instance()
	get_parent().add_child(particle)
	var offset = Vector3.UP * 2 + global_transform.basis.z * -1.6
	particle.global_transform.origin = global_transform.origin + offset
	particle.global_rotation.y = global_rotation.y
	particle.scale = Vector3.ONE * 0.5
	particle.emitting = true
	
	$AnimationPlayer.play("kickbakc")
	
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
