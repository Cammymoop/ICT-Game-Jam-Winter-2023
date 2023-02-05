extends Spatial

var shootParticle = preload("res://TankParticleShoot.tscn")
var dieParticle = preload("res://Scenes/ParticleScenes/TankDieParticle.tscn")
var redMat = preload("res://assets/Materials/RedMat.tres")
var BaseMat = preload("res://assets/Models/Material_010.material")

var target

var turnSpeed = 0.05
var enabled = true
var TankHealth: = 3.0
var IAmTank = true
var timeWhenLastFired = 0
var FireCooldown = 2000

var my_range = 6.5
var max_range = 200.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass#target = get_parent().find_node("Player")

func acquire_target() -> void:
	print("a")
	target = null
	var targets = get_tree().get_nodes_in_group("findable")
	
	var min_dist = max_range
	for t in targets:
		var body = t as PhysicsBody
		var dist_to_target = (global_translation - body.global_translation).length()
		
		if dist_to_target > max_range:
			continue
		if dist_to_target > min_dist:
			continue
		
		min_dist = dist_to_target
		target = body


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !enabled:
		return
	
	if !target:
		acquire_target()
		if !target:
			return
	
	var newTarget = target.global_translation
	newTarget.y = global_translation.y
	
	var dist = (global_translation - newTarget).length()
	print(global_translation, " ", newTarget)
	if dist <= my_range:
	
		$LookAt.look_at(newTarget,Vector3.UP)
		global_transform = global_transform.interpolate_with($LookAt.global_transform,turnSpeed)
	
		var in_range = $Area.get_overlapping_bodies()
	
		for body in in_range:
			if body == $KinematicBody:
				continue
			if timeWhenLastFired + FireCooldown < Time.get_ticks_msec():
				Fire()
	else:
		$LookAt.look_at(newTarget,Vector3.UP)
		var angle = global_transform.basis.get_rotation_quat().angle_to($LookAt.global_transform.basis.get_rotation_quat())
		if angle > PI/12:
			global_transform = global_transform.interpolate_with($LookAt.global_transform,turnSpeed)
		
		$RayCast.force_raycast_update()
		var new_pos = $RayCast.get_collision_point()
		global_translation = new_pos
		
		
	
	
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
	target = null
	
func takeDamage(damage):
	TankHealth -= damage
	get_node("Cube").set_surface_material(0, redMat)
	print(TankHealth)
	if(TankHealth <= 0):
		Die()
		return
	
	yield(get_tree().create_timer(0.25), "timeout")
	get_node("Cube").set_surface_material(0, BaseMat)
		
func Die():
	var particle = dieParticle.instance()
	get_parent().add_child(particle)
	particle.global_transform.origin = global_transform.origin + Vector3.UP * 2
	particle.emitting = true
	queue_free()
