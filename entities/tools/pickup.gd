extends RigidBody2D
class_name Pickup

signal picked_up

@export var frequency := 2.0

@onready var _sprite := $sprite as Sprite2D

var _time := 0.0


func action(_values: Dictionary) -> void:
    pass


func _process(delta: float) -> void:
    _time += delta
    _sprite.position.y = cos(_time * frequency)


func _on_body_entered(_body: Player) -> void:
    pass
