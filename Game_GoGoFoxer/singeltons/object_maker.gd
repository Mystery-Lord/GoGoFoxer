extends Node

enum BULLET_TYPE {PLAYER, ENEMY}
enum SCENE_TYPE {EXPLOSION, PICKUP}

const BULLETS = {
	BULLET_TYPE.PLAYER: preload("res://bullets/bullet_player/player_bullet.tscn"),
	BULLET_TYPE.ENEMY: preload("res://bullets/bullet_enemy/bullet_enemy.tscn")
}

const SCENES = {
	SCENE_TYPE.EXPLOSION: preload("res://enemy_explosion/enemy_explosion.tscn"),
	SCENE_TYPE.PICKUP: preload("res://fruit_pickup/fruit_pickup.tscn")
}

func add_child_deferred(child_instance) -> void:
	get_tree().root.add_child(child_instance)
	
func call_add_child(child_instance) -> void:
	call_deferred("add_child_deferred", child_instance)

func create_bullet(speed: float, direction: Vector2, strat_position: Vector2, 
					life_span: float, key: BULLET_TYPE) -> void:
	var new_bullet = BULLETS[key].instantiate()
	new_bullet.setup(direction, life_span, speed)
	new_bullet.global_position = strat_position
	call_add_child(new_bullet)
	
#func create_explosion(start_position: Vector2) -> void:
	#var new_explosion = explosion_scene.instantiate()
	#new_explosion.global_position = start_position
	#call_add_child(new_explosion)
	
func create_scene(start_position: Vector2, type: SCENE_TYPE) -> void:
	var new_scene = SCENES[type].instantiate()
	new_scene.global_position = start_position
	call_add_child(new_scene)
