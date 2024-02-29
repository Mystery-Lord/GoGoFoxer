extends Node2D

@onready var sound = $Sound
@onready var shoot_timer = $ShootTimer

@export var speed: float = 100.0
@export var life_span: float = 20.0
@export var bullet_type: ObjectMaker.BULLET_TYPE
@export var shoot_dely: float = 0.5

var _can_shoot: bool = true

func _ready():
	shoot_timer.wait_time = shoot_dely

func shoot_process(direction: Vector2) -> void:
	if _can_shoot == false:
		return
	
	_can_shoot = false
	SoundManager.play_clip(sound, SoundManager.SOUND_LASER)
	ObjectMaker.create_bullet(speed, direction, global_position, life_span,
								bullet_type)
	shoot_timer.start()

func _on_shoot_timer_timeout():
	_can_shoot = true
