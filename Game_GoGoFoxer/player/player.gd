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
@onready var debug_label = $DebugLabel
@onready var sound_player = $SoundPlayer
@onready var collision_idle = $CollisionIdle
@onready var collision_sneak = $CollisionSneak
@onready var collision_run = $CollisionRun
@onready var collision_jump = $CollisionJump
@onready var collision_fall = $CollisionFall


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
	update_debug_label()

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
		SoundManager.play_clip(sound_player, SoundManager.SOUND_JUMP)
	
func disable_collision_shapes(state: PLAYER_STATE) -> void:
	collision_idle.disabled = true
	collision_run.disabled = true
	collision_jump.disabled = true
	collision_fall.disabled = true
	collision_sneak.disabled = true
	
	match state:
		PLAYER_STATE.IDLE:
			collision_idle.disabled = false
		PLAYER_STATE.RUN:
			collision_run.disabled = false
		PLAYER_STATE.SPRINT:
			collision_run.disabled = false
		PLAYER_STATE.JUMP:
			collision_jump.disabled = false
		PLAYER_STATE.FALL:
			collision_fall.disabled = false
		PLAYER_STATE.SNEAK:
			collision_sneak.disabled = false
	

func set_state(new_state: PLAYER_STATE) -> void:
	if new_state == player_state:
		return
		
	disable_collision_shapes(new_state)
	
	if player_state == PLAYER_STATE.FALL:
		if new_state == PLAYER_STATE.IDLE or new_state == PLAYER_STATE.RUN:
			SoundManager.play_clip(sound_player, SoundManager.SOUND_LAND)
	
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
		
func update_debug_label() -> void:
		debug_label.text = "floor: %s\n%s\n%.0f, %.0f" % [
			is_on_floor(),
			PLAYER_STATE.keys()[player_state],
			velocity.x,
			velocity.y
		]
