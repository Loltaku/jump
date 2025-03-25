extends CharacterBody2D

const SPEED = 100.0
const BIG_JUMP_VELOCITY = -300.0
const SMALL_JUMP_VELOCITY = -150.0

func _physics_process(delta: float) -> void:
	# 添加重力
	if not is_on_floor():
		velocity += get_gravity() * delta

	#处理跳跃
	if Input.is_action_just_pressed("jump") and is_on_floor():
		if.y = SMALL_JUMP_VELOCITY
	
	#处理移动
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
