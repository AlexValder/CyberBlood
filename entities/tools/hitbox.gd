extends Area2D
class_name HitBox

@export var damage := 1
@export var is_enemy := true


func _ready() -> void:
    self.collision_layer = 64 if is_enemy else 32
    self.collision_mask = 0
