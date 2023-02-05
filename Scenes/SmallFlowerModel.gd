extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var startScale

# Called when the node enters the scene tree for the first time.
func _ready():
	startScale = transform.basis
	print(startScale)
	transform.basis = transform.basis.scaled(Vector3.ZERO)
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "transform:basis" ,startScale, 0.5)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
