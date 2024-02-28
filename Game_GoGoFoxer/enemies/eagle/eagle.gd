extends EnemyBase

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var player_detector = $PlayerDetector
@onready var direction_timer = $DirectionTimer

const FLY_SPEED: Vector2 = Vector2(40, 15)
const WAIT_TIME: Vector2 = Vector2(1.0, 3.0)

var fly_direction: Vector2 = Vector2.ZERO

func _ready():
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	super._physics_process(delta)
	velocity = fly_direction
	move_and_slide()
	
func set_and_flip() -> void:
	var x_direction = sign(_player_ref.global_position.x - global_position.x)
	if x_direction > 0:
		animated_sprite_2d.flip_h  = true
	else:
		animated_sprite_2d.flip_h = false
		
	fly_direction = Vector2(x_direction, 1) * FLY_SPEED

func manage_fly_action() -> void:
	set_and_flip()
	set_rand_wait_timer()
	direction_timer.start()
	

func _on_visible_on_screen_notifier_2d_screen_entered():
	animated_sprite_2d.play("fly")
	manage_fly_action()
	
func set_rand_wait_timer() -> void:
	direction_timer.wait_time = randf_range(WAIT_TIME.x, WAIT_TIME.y)


func _on_direction_timer_timeout():
	manage_fly_action()
