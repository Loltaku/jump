extends CharacterBody2D

# 节点引用
@onready var movement_system: MovementSystem = $MovementSystem
@onready var jump_system: JumpSystem = $JumpSystem
@onready var animation_system: AnimationSystem = $AnimationSystem
@onready var edge_detector: EdgeDetector = $EdgeDetector

# 基础参数
var gravity := ProjectSettings.get_setting("physics/2d/default_gravity") as float
var was_on_floor := false

# 新增边缘吸附参数
@export var edge_snap_speed := 20.0  # 控制吸附速度的参数
@export var edge_snap_threshold := 2.0  # 吸附完成阈值

func _physics_process(delta: float) -> void:
	# 更新地面状态
	var is_floor = is_on_floor()
	jump_system.update_floor_state(is_floor, was_on_floor)
	was_on_floor = is_floor
	
	# 处理重力
	if not is_floor:
		velocity.y += gravity * delta
	
	# 获取输入
	var direction = Input.get_axis("move_left", "move_right")
	
	# 系统协同
	velocity.x = movement_system.calculate_velocity(velocity.x, direction, delta, is_floor)
	jump_system.process_jump()
	
	# 边缘吸附处理
	if edge_detector.is_edge_detected and velocity.y > 0:
		perform_edge_snap(delta)
	
	# 执行移动
	move_and_slide()
	
	# 更新动画
	animation_system.update(direction, is_floor, velocity)

func perform_edge_snap(delta: float):
	# 平滑吸附移动
	global_position = global_position.move_toward(
		edge_detector.target_position, 
		edge_snap_speed * delta
	)
	
	# 重置下落速度
	if global_position.distance_to(edge_detector.target_position) < edge_snap_threshold:
		velocity.y = 0
		is_on_floor() # 强制更新地面状态
