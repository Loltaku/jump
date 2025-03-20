class_name MovementSystem
extends Node

# 导出参数（可在编辑器调整）
@export_category("Movement Settings")
@export var max_speed := 300.0
@export var ground_accel := 800.0
@export var air_accel := 400.0
@export var deceleration := 1200.0

func calculate_velocity(current_speed: float, direction: float, delta: float, is_floor: bool) -> float:
	var target_speed = direction * max_speed
	var accel = ground_accel if is_floor else air_accel
	
	return move_toward(
		current_speed,
		target_speed,
		(accel if direction != 0 else deceleration) * delta
	)
