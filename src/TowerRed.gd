extends Spatial

signal activated
signal deactivated

var activated: = false
var growth_timer = 0.0
var time_to_grow = 7.0
var growing: = false

func start_growth() -> void:
	growing = true

func _process(delta):
	if growing:
		growth_timer += delta
		if growth_timer >= time_to_grow:
			growing = false
			activate()


func activate() -> void:
	emit_signal("activated", self)


func _on_FruitDetector_body_entered(body):
	if body.name == "Player" and body.has_fruit:
		body.drop_seed()
		
		start_growth()
