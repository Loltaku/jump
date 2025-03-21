# Player.gd 修正版
extends CharacterBody2D

# 节点引用
@onready var movement_system: MovementSystem = $MovementSystem
@onready var jump_system: JumpSystem = $JumpSystem
@onready var animation_system: AnimationSystem = $AnimationSystem
@onready var edge_detector: EdgeDetector = $EdgeDetector
@onready var wall_system: WallSystem = $WallSystem

# 基础参数
var gravity := ProjectSettings.get_setting("physics/2d/default_gravity") as float
var was_on_floor := false
var direction := 0.0  # 修复direction作用域问题
var is_floor := false # 修复is_floor作用域问题

# 边缘吸附参数
@export var edge_snap_speed := 20.0
@export var edge_snap_threshold := 2.0

func _physics_process(delta: float) -> void:
	# 更新地面状态
	is_floor = is_on_floor()
	jump_system.update_floor_state(is_floor, was_on_floor)
	was_on_floor = is_floor
	
	# 处理重力
	if not is_floor:
		velocity.y += gravity * delta
	
	# 获取输入
	direction = Input.get_axis("move_left", "move_right")
	
	# 系统协同
	velocity.x = movement_system.calculate_velocity(velocity.x, direction, delta, is_floor)
	jump_system.process_jump()
	
	# 边缘吸附处理
	if edge_detector.is_edge_detected and velocity.y > 0:
		perform_edge_snap(delta)
	
	# 墙壁系统更新（移动到主流程）
	var is_wall_sliding = wall_system.check_walls()
	
	# 滑墙速度控制
	if is_wall_sliding and velocity.y > wall_system.wall_slide_speed:
		velocity.y = wall_system.wall_slide_speed
	
	# 处理蹭墙跳
	jump_system.process_wall_jump(wall_system)
	
	# 执行移动
	move_and_slide()
	
	# 更新动画（参数修正）
	animation_system.update(
		direction, 
		is_floor, 
		velocity, 
		is_wall_sliding, 
		wall_system.last_wall_normal if wall_system else 1
	)

func perform_edge_snap(delta: float):
	global_position = global_position.move_toward(
		edge_detector.target_position, 
		edge_snap_speed * delta
	)
	if global_position.distance_to(edge_detector.target_position) < edge_snap_threshold:
		velocity.y = 0
		is_on_floor()
