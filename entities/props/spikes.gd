extends Node2D

@export var is_static := true
@export var damage := 10

@onready var _anim := $anim as AnimationPlayer


func disable() -> void:
    _anim.seek(1.0, true)
    _anim.pause()
    $damage/shape.disabled = true


func _ready() -> void:
    $damage.damage = damage

    if is_static:
        _anim.stop()
