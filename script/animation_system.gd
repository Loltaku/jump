class_name AnimationSystem
extends Node

# 节点引用
@onready var sprite: AnimatedSprite2D = $"../AnimatedSprite2D"

func update(direction: float, is_floor: bool, velocity: Vector2):
	# 方向翻转
	if abs(direction) > 0.1:
		sprite.flip_h = direction < 0
	
	# 状态判断
	if !is_floor:
		sprite.play("jump" if velocity.y < 0 else "fall")
	else:
		sprite.play("run" if abs(velocity.x) > 10 else "idle")
