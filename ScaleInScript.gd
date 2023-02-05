extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var DoesDie = false
var startScale

# Called when the node enters the scene tree for the first time.
func _ready():
	startScale = scale
	transform.basis = transform.basis.scaled(Vector3.ZERO)
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale" ,startScale, 0.5)
	pass # Replace with function body.
	
	if DoesDie:
		tween.connect("finished", self, "shrink")
	
func shrink():
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "scale" ,Vector3.ZERO, 0.5)
	
	tween.connect("finished", self, "KillSelf")
	
func KillSelf():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
