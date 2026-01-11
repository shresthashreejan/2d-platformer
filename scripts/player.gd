extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -300.0
const DASH_SPEED = 500.0

var dash = false;

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var dash_timer = $Timer

var air_jumps = 1
var current_air_jumps = 0

var coyote_timer = 0.0
const COYOTE_TIME_THRESHOLD = 1.0

var jump_buffer_timer = 0.0
const JUMP_BUFFFER_TIME_THRESHOLD = 0.1

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		current_air_jumps = air_jumps
		coyote_timer = COYOTE_TIME_THRESHOLD

	if coyote_timer > 0:
		coyote_timer -= delta
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump_buffer_timer = JUMP_BUFFFER_TIME_THRESHOLD

	if Input.is_action_just_pressed("dash"):
		dash = true;
		dash_timer.start()

	if jump_buffer_timer > 0:
		if is_on_floor() or coyote_timer > 0:
			velocity.y = JUMP_VELOCITY
			jump_buffer_timer = 0
			coyote_timer = 0
		elif current_air_jumps > 0:
			velocity.y = JUMP_VELOCITY * 0.8
			current_air_jumps -= 1
			jump_buffer_timer = 0

	var direction := Input.get_axis("move_left", "move_right")

	if direction:
		if dash:
			velocity.x = direction * DASH_SPEED
		else:
			velocity.x = direction * SPEED
		if animated_sprite_2d:
			animated_sprite_2d.flip_h = (direction < 0)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _on_timer_timeout() -> void:
	dash = false