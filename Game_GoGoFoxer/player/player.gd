extends CharacterBody2D

class_name Player

const GRAVITY_RANGE: Vector2 = Vector2(800.0, 1200.0)
const RUN_SPEED: float = 200
const SPRINT_SPEED: float = 300
const SNEAK_SPEED: float = 50
const HURT_TIME: float = 0.3
const JUMP_VELOCITY: float = -240.0

@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer

enum PLAYER_STATE {IDLE, RUN, JUMP, FALL, HURT, SNEAK, SPRINT}

var player_state: PLAYER_STATE = PLAYER_STATE.IDLE

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if is_on_floor() == false:
		calculate_gravity(delta)

	get_action_input()
	move_and_slide()
	calculate_states()

func calculate_gravity(delta) -> void:
	var gravity_factor = clampf(abs(velocity.y) / 1200.0, 0.0, 1.0)
	var realtime_gravity = lerp(GRAVITY_RANGE.x, GRAVITY_RANGE.y, gravity_factor)
	velocity.y += realtime_gravity * delta
	
func calculate_states() -> void:
	if player_state == PLAYER_STATE.HURT:
		return
		
	if is_on_floor():
		if velocity.x == 0:
			set_state(PLAYER_STATE.IDLE)
		else:
			if Input.is_action_pressed("sprint"):
				set_state(PLAYER_STATE.SPRINT)
			elif Input.is_action_pressed("sneak"):
				set_state(PLAYER_STATE.SNEAK)
			else:
				set_state(PLAYER_STATE.RUN)
	else:
		if velocity.y > 0:
			set_state(PLAYER_STATE.FALL)
		else:
			set_state(PLAYER_STATE.JUMP)
	
func get_action_input() -> void:
	velocity.x = 0
	var player_speed = RUN_SPEED
	
	if Input.is_action_pressed("sprint"):
		player_speed = SPRINT_SPEED
	if Input.is_action_pressed("sneak"):
		player_speed = SNEAK_SPEED
	
	if Input.is_action_pressed("left"):
		velocity.x = -player_speed
		sprite_2d.flip_h = true
	elif Input.is_action_pressed("right"):
		velocity.x = player_speed
		sprite_2d.flip_h = false
		
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
func set_state(new_state: PLAYER_STATE) -> void:
	if new_state == player_state:
		return
	
	player_state = new_state
	
	match player_state:
		PLAYER_STATE.IDLE:
			animation_player.play("idle")
		PLAYER_STATE.RUN:
			animation_player.play("run")
		PLAYER_STATE.JUMP:
			animation_player.play("jump")
		PLAYER_STATE.FALL:
			animation_player.play("fall")
		PLAYER_STATE.SPRINT:
			animation_player.play("sprint")
		PLAYER_STATE.SNEAK:
			animation_player.play("sneak")
			
