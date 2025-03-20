extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var front_ray: RayCast2D = $front_ray
@onready var bottom_ray: RayCast2D = $bottom_ray
@onready var edge_ray: RayCast2D = $edge_ray

const MAX_SPEED := 80.0
const GROUND_ACCEL := 90.0  # 地面加速
const GROUND_DECEL := 1000.0  # 地面减速
const AIR_ACCEL := 45.0  # 地面加速 * 0.5
const JUMP_VELOCITY := -250.0
const COYOTE_TIME := 0.15

var gravity := ProjectSettings.get_setting("physics/2d/default_gravity") as float
var was_on_floor := false

func _physics_process(delta: float) -> void:
	handle_gravity(delta)
	handle_jump()
	handle_movement(delta)
	update_animation()
	move_and_slide()

func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

func handle_jump() -> void:
	var is_on_floor_now = is_on_floor()
	
	# 土狼时间管理
	if was_on_floor and not is_on_floor_now:
		coyote_timer.start(COYOTE_TIME)
	was_on_floor = is_on_floor_now
	
	# 跳跃执行
	if Input.is_action_just_pressed("jump") and can_jump():
		velocity.y = JUMP_VELOCITY
		coyote_timer.stop()

func handle_movement(delta: float) -> void:
	var direction = Input.get_axis("move_left", "move_right")
	var accel = GROUND_ACCEL if is_on_floor() else AIR_ACCEL
	var decel = GROUND_DECEL if is_on_floor() else 0.0
	
	velocity.x = move_toward(
		velocity.x, 
		direction * MAX_SPEED, 
		(accel if direction else decel) * delta
	)

func update_animation() -> void:
	animated_sprite.flip_h = velocity.x < 0 if abs(velocity.x) > 10 else animated_sprite.flip_h
	
	if not is_on_floor():
		animated_sprite.play("jump" if velocity.y < 0 else "fall")
	else:
		animated_sprite.play("run" if abs(velocity.x) > 10 else "idle")

func can_jump() -> bool:
	return (is_on_floor() 
		or not coyote_timer.is_stopped()
		or (bottom_ray.is_colliding() 
			and front_ray.is_colliding() 
			and edge_ray.is_colliding()))
