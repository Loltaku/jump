extends CharacterBody2D  

const SPEED = 100.0  
const JUMP_VELOCITY = -239.0  
const COYOTE_DURATION: float = 0.039  # 土狼时间

var coyote_time_counter: float = 0.000  # 土狼时间计数器  
var can_jump: bool = true  # 跟踪是否可以跳跃  

func _physics_process(delta: float) -> void:  
	# 应用重力  
	if not is_on_floor():  
		velocity += get_gravity() * delta  
		coyote_time_counter += delta  # 更新土狼时间计数器  
	else:  
		# 落地后处理  
		if coyote_time_counter <= COYOTE_DURATION:  
			can_jump = true  # 允许跳跃  
		coyote_time_counter = 0.000  # 重置计数器  

	handle_jump()  
	handle_movement()  
	move_and_slide()  

# 移动  
func handle_movement():  
	velocity.x = Input.get_axis("ui_left", "ui_right") * SPEED  

# 跳跃  
func handle_jump():  
	if Input.is_action_just_pressed("jump") and can_jump:  
		velocity.y = JUMP_VELOCITY  # 执行跳跃  
		can_jump = false  # 跳跃后设置为不可跳跃  
