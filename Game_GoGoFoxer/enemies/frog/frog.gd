extends EnemyBase

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var jump_timer = $JumpTimer

const JUMP_VELOCITY: Vector2 = Vector2(80, -150)
const JUMP_COOL_DOWN_TIME: Vector2 = Vector2(1.0, 5.0)

var _jump: bool = false
var _detect_player: bool = false

func _ready():
	super._ready()
	start_timer()
	
func _physics_process(delta):
	super._physics_process(delta)
	
	if is_on_floor() == false:
		velocity.y += _gravity * delta
	else:
		velocity.x = 0
		animated_sprite_2d.play("idle")
	
	start_jump()
	move_and_slide()
	flip_direction()
	
func flip_direction() -> void:
	#if _player_ref.position.x > global_position.x and animated_sprite_2d.flip_h == false:
		#animated_sprite_2d.flip_h = true
	#elif _player_ref.position.x <= global_position.x and animated_sprite_2d.flip_h == true:
		#animated_sprite_2d.flip_h = false
	var x_direction = sign(_player_ref.position.x - global_position.x)
	if x_direction > 0:
		animated_sprite_2d.flip_h  = true
	else:
		animated_sprite_2d.flip_h = false
		
func _on_jump_timer_timeout():
	_jump = true
	
func _on_visible_on_screen_notifier_2d_screen_entered():
	#print("seen player")
	_detect_player = true
	
func start_jump() -> void:
	if is_on_floor() == false:
		return
		
	if _detect_player == false or _jump == false:
		return
		
	velocity = JUMP_VELOCITY
	
	if animated_sprite_2d.flip_h == false:
		velocity.x = velocity.x * -1
		
	_jump = false
	
	animated_sprite_2d.play("jump")
	start_timer()
	
func start_timer() -> void:
	jump_timer.wait_time = randf_range(JUMP_COOL_DOWN_TIME.x, JUMP_COOL_DOWN_TIME.y)
	jump_timer.start()
