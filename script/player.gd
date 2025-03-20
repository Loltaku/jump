extends CharacterBody2D

# 节点引用
@onready var movement_system: MovementSystem = $MovementSystem
@onready var jump_system: JumpSystem = $JumpSystem
@onready var animation_system: AnimationSystem = $AnimationSystem

# 基础参数
var gravity := ProjectSettings.get_setting("physics/2d/default_gravity") as float
var was_on_floor := false

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
	jump_system.process_jump()  # 修改为统一入口
	
	# 执行移动
	move_and_slide()
	
	# 更新动画
	animation_system.update(direction, is_floor, velocity)
