extends BaseLevel

@onready var _secret_area := $tilemap/secret_area as TileMap


func _ready() -> void:
    super._ready()
    var hp = GameManager.save_data.get_map_change(biome, id, "hp_upgrade")
    if hp == "1":
        $env/health_upgrade.queue_free()


func _on_secret_area_body_entered(player: Player) -> void:
    if player == null:
        return

    if _tween:
        _tween.kill()
    _tween = create_tween()
    _tween.tween_property(_secret_area, "modulate:a", 0.0, 0.5)


func _on_secret_area_body_exited(player: Player) -> void:
    if player == null:
        return

    if _tween:
        _tween.kill()
    _tween = create_tween()
    _tween.tween_property(_secret_area, "modulate:a", 1.0, 0.5)


func _on_health_upgrade_picked_up() -> void:
    GameManager.save_data.push_map_change(biome, id, "hp_upgrade", "1")
