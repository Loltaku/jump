class_name JumpSystem
extends Node

signal jumped()

@export var jump_velocity := -400.0
@export var coyote_time := 0.15

var can_jump := true

func try_jump(input_pressed: bool):
	if input_pressed and can_jump:
		jumped.emit()
		can_jump = false
