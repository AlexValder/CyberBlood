extends BaseLevel

@onready var _spawner1 := $env/fireball_enemy_spawner as Marker2D
@onready var _spawner2 := $env/fireball_player_spawner as Marker2D


func get_extends() -> Vector4i:
    var limits := super.get_extends()
    limits.y -= 500
    return limits


func _on_timer_timeout() -> void:
    var fireball1 := FireBall.spawn_fireball()
    fireball1.direction_movement = Vector2.RIGHT
    fireball1.speed = 2.5
    add_sibling(fireball1)
    fireball1.make_enemy()
    fireball1.global_position = _spawner1.global_position

    var fireball2 := FireBall.spawn_fireball()
    fireball2.direction_movement = Vector2.RIGHT
    fireball2.speed = 2.5
    add_sibling(fireball2)
    fireball2.make_player()
    fireball2.global_position = _spawner2.global_position
