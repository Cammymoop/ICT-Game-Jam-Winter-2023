extends Spatial


var activated: = false
var growth_progress = 0.0

func start_growth() -> void:
	pass


func _on_FruitDetector_body_entered(body):
	if body.name == "Player" and body.has_seed:
		body.drop_seed()
		
		start_growth()
