extends CharacterBody2D

@onready var jump_press_timer: Timer = $JumpPressTimer

const SPEED = 100.0
const BIG_JUMP_VELOCITY = -300.0
const SMALL_JUMP_VELOCITY = -150.0

var JUMP_PRESS_TIMER = false

func _physics_process(delta: float) -> void:
	# 添加重力
	if not is_on_floor():
		velocity += get_gravity() * delta

	#处理跳跃
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump_press_timer.start()
		# 跳跃长按检测
	func _on_jump_press_timer_timeout() -> void:
		JUMP_PRESS_TIMER = true
			if JUMP_PRESS_TIMER = true:
				velocity.y = BIG_JUMP_VELOCITY
			else:
				velocity.y = SMALL_JUMP_VELOCITY
	
	#处理移动
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
