extends Area2D

var _direction: Vector2 = Vector2.RIGHT
var _life_span: float = 10.0
var _life_time: float = 0.0

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	check_life_time(delta)
	position += _direction * delta
	
func check_life_time(delta: float) -> void:
	_life_time += delta
	if _life_time > _life_span:
		queue_free()

func _on_area_entered(area):
	queue_free()
	
func setup(dir: Vector2, life_span:float, speed: float) -> void:
	_direction = dir.normalized() * speed
	_life_span = life_span
