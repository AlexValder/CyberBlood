extends Area2D
class_name HitBox


@export var damage := 1


func _init() -> void:
    self.collision_layer = 0b10000
    self.collision_mask = 0b0
