class_name AnimationSystem
extends Node

@onready var sprite: AnimatedSprite2D = $"../AnimatedSprite2D"

func update(direction: float, is_airborne: bool):
	if is_airborne:
		sprite.play("jump" if velocity.y < 0 else "fall")
	else:
		sprite.play("run" if abs(direction) > 0 else "idle")
	sprite.flip_h = direction < 0
