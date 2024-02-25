extends Node2D

@onready var player_camera = $PlayerCamera
@onready var player = $Player

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	player_camera.position = player.position
