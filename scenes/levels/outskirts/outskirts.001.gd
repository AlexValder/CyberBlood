extends BaseLevel

@onready var _hide_corridor := $tilemap/hiding as TileMap
@onready var _tween: Tween


func _on_corridor_hide_body_entered(player: Player) -> void:
    if player == null:
        return

    if _tween:
        _tween.kill()
    _tween = create_tween()
    _tween.tween_property(_hide_corridor, "modulate:a", 0.0, 0.5)


func _on_corridor_hide_body_exited(player: Player) -> void:
    if player == null:
        return

    if _tween:
        _tween.kill()
    _tween = create_tween()
    _tween.tween_property(_hide_corridor, "modulate:a", 1.0, 0.5)
