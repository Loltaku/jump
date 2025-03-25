extends CharacterBody2D


const JUMP_VELOCITY = -300.0

func _physics_process(delta: float) -> void:
	# 添加重力
	if not is_on_floor():
		velocity += get_gravity() * delta

	#处理跳跃
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	move_and_slide()
