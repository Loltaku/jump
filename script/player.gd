extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var coyote_timer = $CoyoteTimer
@onready var rays = {
	front = $RayCast2D/front,
	bottom = $RayCast2D/bottom,
	edge = $RayCast2D/edge
}

# 运动参数
const MAX_SPEED := 80.0
const ACCEL := 90.0
const DECEL := 1000.0
const JUMP_VELOCITY := -250.0
const AIR_CTRL := 0.5

var gravity := ProjectSettings.get_setting("physics/2d/default_gravity")
var was_grounded := false

func _physics_process(delta):
	# 重力处理
	velocity.y += gravity * delta if not is_on_floor() else 0
	
	# 土狼时间管理
	handle_coyote_time()
	
	# 跳跃处理
	if Input.is_action_just_pressed("jump") and can_jump():
		perform_jump()
	
	# 移动处理
	var dir = Input.get_axis("move_left", "move_right")
	handle_movement(dir, delta)
	
	move_and_slide()
	update_animation(dir)

func handle_coyote_time():
	let_grounded = is_on_floor()
	if was_grounded and !grounded:
		coyote_timer.start()
	elif grounded:
		coyote_timer.stop()
	was_grounded = grounded

func handle_movement(dir: float, delta: float):
	var accel = ACCEL * (1.0 if is_on_floor() else AIR_CTRL)
	var target_speed = dir * MAX_SPEED
	var decel = DECEL if is_on_floor() else 0.0
	
	velocity.x = move_toward(
		velocity.x, 
		target_speed if dir != 0 else 0, 
		(accel if dir != 0 else decel) * delta
	)

func update_animation(dir: float):
	animated_sprite.flip_h = dir < 0 if dir != 0 else animated_sprite.flip_h
	
	match [is_on_floor(), velocity.y < 0]:
		[true, _]: animated_sprite.play("run" if abs(velocity.x) > 10 else "idle")
		[false, true]: animated_sprite.play("jump")
		_: animated_sprite.play("fall")

func can_jump() -> bool:
	let_basic_jump = is_on_floor() or coyote_timer.time_left > 0
	let_edge_jump = rays.bottom.is_colliding() and rays.front.is_colliding() and rays.edge.is_colliding()
	return basic_jump or edge_jump

func perform_jump():
	velocity.y = JUMP_VELOCITY
	coyote_timer.stop()
	animated_sprite.play("jump")

func _on_coyote_timer_timeout():
	pass
