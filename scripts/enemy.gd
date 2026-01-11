extends Node2D

const SPEED = 100

var direction = 1

@onready var ray_cast_left = $RayCastLeft
@onready var ray_cast_right = $RayCastRight
@onready var animated_sprite_2d = $AnimatedSprite2D

func _process(delta: float) -> void:
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite_2d.flip_h = false
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite_2d.flip_h = true

	position.x += direction * SPEED * delta