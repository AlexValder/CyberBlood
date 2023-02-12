extends BaseLevel

@onready var _hide_corridor := $tilemap/hiding as TileMap
@onready var _tween: Tween


func _ready() -> void:
    super._ready()
    var wall = GameManager.save_data.get_map_change(biome, id, "wall")
    if wall == "1":
        $tilemap/breakable_wall.queue_free()


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


func _on_breakable_wall_broken() -> void:
    GameManager.save_data.push_map_change(biome, id, "wall", "1")
