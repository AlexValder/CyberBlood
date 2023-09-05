extends Marker2D
class_name Shooter

@export var direction := Vector2.UP
@export_range(0.01, 2.0, 0.01) var interval := 0.5
@export var started := true

@onready var _timer := $timer as Timer


func _ready() -> void:
    _timer.wait_time = interval
    if started:
        _timer.start()


func _on_timer_timeout() -> void:
    var proj := _get_projectile()
    proj.direction_movement = direction
    add_child(proj)
    proj.make_enemy()


func _get_projectile() -> FireBall:
    var fireball := FireBall.spawn_fireball()
    return fireball
