extends Node

var attackParticle = preload("res://Scenes/ParticleScenes/AreaEffectParticle.tscn")
var timeWhenLastFired = 0
var FireCooldown = 2000

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var in_range = $"../Area".get_overlapping_bodies()
	
	for body in in_range:
		if timeWhenLastFired + FireCooldown < Time.get_ticks_msec():
			attck(body.get_parent())
			
func attck(node):
	timeWhenLastFired = Time.get_ticks_msec()
	var particle = attackParticle.instance()
	get_parent().add_child(particle)
	#var offset = Vector3.UP * 2 + global_transform.basis.z * -1.6
	particle.global_transform.origin = get_parent().global_transform.origin
	particle.scale = Vector3.ONE * 0.5
	particle.emitting = true
	particle.get_child(0).emitting = true
	particle.get_child(1).emitting = true
	
	node.takeDamage(1)
