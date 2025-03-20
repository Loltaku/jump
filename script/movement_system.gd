class_name MovementSystem
extends Node

@export var max_speed := 300.0
@export var acceleration_curve: Curve
@export var deceleration_curve: Curve

var current_speed := 0.0

func calculate_velocity(direction: float, delta: float) -> float:
	var speed_ratio = abs(current_speed) / max_speed
	var curve = acceleration_curve if direction != 0 else deceleration_curve
	var acceleration = curve.sample_baked(speed_ratio) * max_speed
	return move_toward(current_speed, direction * max_speed, acceleration * delta)
