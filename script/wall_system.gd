class_name WallSystem
extends Node

@export var wall_slide_speed := 200.0
@export var wall_jump_force := Vector2(400, -350)
@export var wall_stick_time := 0.2

# 节点路径修正
@onready var left_ray: RayCast2D = $WallRays/Left
@onready var right_ray: RayCast2D = $WallRays/Right
@onready var wall_jump_timer: Timer = $WallJumpTimer

var is_wall_sliding := false
var last_wall_normal := 1

func _ready():
	# 配置射线参数
	left_ray.enabled = true
	right_ray.enabled = true
	wall_jump_timer.wait_time = wall_stick_time

# ...剩余代码保持不变...

func check_walls() -> bool:
	is_wall_sliding = left_ray.is_colliding() or right_ray.is_colliding()
	if is_wall_sliding:
		last_wall_normal = -1 if left_ray.is_colliding() else 1
		wall_jump_timer.start()
	return is_wall_sliding

func can_wall_jump() -> bool:
	return is_wall_sliding or not wall_jump_timer.is_stopped()
