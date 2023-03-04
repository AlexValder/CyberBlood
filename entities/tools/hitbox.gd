extends Area2D
class_name HitBox

@export var damage := 1
@export var damages_enemy := false
@export var damages_player := true


func _ready() -> void:
    self.set_collision_layer_value(6, damages_enemy)
    self.set_collision_layer_value(7, damages_player)
    self.collision_mask = 0
