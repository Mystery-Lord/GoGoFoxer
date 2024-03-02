extends Area2D

@onready var animated_sprite_2d = $AnimatedSprite2D

const FRUITS: Array = ["melon", "kiwi", "cherry", "banana"]
const GRAVITY: float = 150.0
const JUMP_Velocity: float = -60.0
const POINTS: int = 2

var _start_position_y: float = 0.0
var _speed_y: float = JUMP_Velocity
var _stopped: bool = false

func _ready():
	_start_position_y = global_position.y
	animated_sprite_2d.play(FRUITS.pick_random())


func _process(delta):
	if _stopped == true:
		return
	
	position.y += _speed_y * delta
	_speed_y += GRAVITY * delta
	
	if global_position.y > _start_position_y:
		_stopped = true

func be_picked() -> void:
	set_process(false)
	hide()
	queue_free()
	
func _on_life_timer_timeout():
	be_picked()


func _on_area_entered(area):
	print("Pickup collision")
	SignalManager.on_pickup_hit.emit(POINTS)
	be_picked()
