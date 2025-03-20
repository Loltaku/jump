# EdgeDetector.gd
class_name EdgeDetector
extends Area2D

@export var edge_snap_speed := 20.0    # 吸附速度
@export var body_height := 32.0        # 角色碰撞体高度

var is_edge_detected := false
var target_position := Vector2.ZERO

signal edge_snap_triggered

func _physics_process(delta):
	var left_hit = $LowerRayLeft.is_colliding()
	var right_hit = $LowerRayRight.is_colliding()
	
	# 单边检测逻辑
	is_edge_detected = (left_hit and not right_hit) or (right_hit and not left_hit)
	
	# 计算吸附目标位置
	if is_edge_detected:
		emit_signal("edge_snap_triggered")
		var ray = $LowerRayLeft if left_hit else $LowerRayRight
		var collision_point = ray.get_collision_point()
		target_position = Vector2(collision_point.x, collision_point.y - body_height/2)

func is_valid_edge() -> bool:
	if not is_edge_detected:
		return false
	
	# 平台厚度检测
	var ray = $LowerRayLeft if $LowerRayLeft.is_colliding() else $LowerRayRight
	var platform = ray.get_collider()
	
	# 排除倾斜平台
	if abs(ray.get_collision_normal().angle()) > PI/6:
		return false
		
	# 平台宽度检查
	var platform_shape = platform.get_shape()
	if platform_shape is RectangleShape2D:
		return platform_shape.size.x > 16  # 最小有效平台宽度
	
	return true
