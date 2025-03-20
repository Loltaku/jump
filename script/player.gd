extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_timer = $CoyoteTimer # 获取计时器
@onready var front_ray = $RayCast2D/front
@onready var bottom_ray = $RayCast2D/bottom
@onready var edge_ray = $RayCast2D/edge


#region 常量配置
const MAX_SPEED := 80.0                                                         # 水平移动最大速度
const ACCELERATION := 90.0                                                       # 加速度（像素/秒²）
const DECELERATION := 1000.0                                                      # 减速度（像素/秒²）
const JUMP_VELOCITY := -250.0                                                    # 跳跃初速度
const AIR_CONTROL := 0.5                                                         # 空中移动控制系数
#endregion

#region 变量配置
# 从项目设置获取重力值（重要修正！）
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var was_on_floor := false
#endregion

func _physics_process(delta: float) -> void:
	#region 重力处理
	if not is_on_floor():
		velocity.y += gravity * delta
	#endregion

	#region 土狼时间计时器
	var is_on_floor_now = is_on_floor()                                          # 地面状态变化检测
	if was_on_floor and not is_on_floor_now:                                     # 刚离开地面
		coyote_timer.stop()                                                      # 如果在地面，停止计时
	elif is_on_floor_now:                                                        # 当前在地面
		coyote_timer.start()
	#endregion
	
	#region 跳跃输入
		func can_jump() -> bool:
		# 基础地面检测
		var basic_ground = is_on_floor() or coyote_timer.time_left > 0
		# 边缘容错检测
		var edge_tolerance = (
			bottom_ray.is_colliding() and 
			front_ray.is_colliding() and 
			edge_ray.is_colliding()
			)
		# 最终跳跃条件：基础条件 或 (底部有地面且处于边缘)
		return Input.is_action_just_pressed("jump") and (
			basic_ground or 
			(bottom_ray.is_colliding() and edge_tolerance)
			)

	if can_jump():
		if not coyote_timer.is_stopped():
			velocity.y = JUMP_VELOCITY
			 # 无论何时跳跃都停止计时器
			coyote_timer.stop()
			# 立即播放跳跃动画
			animated_sprite.play("jump")
	# 更新地面状态记录
	was_on_floor = is_on_floor_now
	#endregion

	#region 移动处理
	var direction := Input.get_axis("move_left", "move_right")                   # 使用自定义输入
	
	# 地面移动
	if is_on_floor():
		handle_ground_movement(direction, delta)
	# 空中移动
	else:  
		handle_air_movement(direction, delta)
	#endregion

	move_and_slide()
	update_animation(direction)                                                 

	#region 移动逻辑函数
func handle_ground_movement(direction: float, delta: float) -> void:
	if direction != 0:
		# 地面加速（使用move_toward实现更精确控制）
		velocity.x = move_toward(
			velocity.x, 
			direction * MAX_SPEED, 
			ACCELERATION * delta
		)
	else:
		# 地面减速
		velocity.x = move_toward(
			velocity.x, 
			0.0, 
			DECELERATION * delta
		)

func handle_air_movement(direction: float, delta: float) -> void:
	# 空中保持部分惯性
	var air_accel = ACCELERATION * AIR_CONTROL
	velocity.x = move_toward(
		velocity.x, 
		direction * MAX_SPEED, 
		air_accel * delta
	)
#endregion

#region 动画控制
 # 分离动画更新逻辑
func update_animation(direction: float) -> void:
	# 方向翻转（优化判断逻辑）
	if direction != 0:
		animated_sprite.flip_h = direction < 0
	
	# 动画状态机
	if not is_on_floor():
		handle_air_animation()
	else:
		handle_ground_animation(direction)

@warning_ignore("unused_parameter")
func handle_ground_animation(direction: float) -> void:
	if abs(velocity.x) > 10:  # 避免微小速度抖动
		animated_sprite.play("run")
	else:
		animated_sprite.play("idle")

func handle_air_animation() -> void:
	# 根据下落速度切换跳跃/下落动画
	if velocity.y < 0:
		animated_sprite.play("jump")
	else:
		animated_sprite.play("fall")
#endregion


func _on_coyote_timer_timeout() -> void:
	pass # Replace with function body.
