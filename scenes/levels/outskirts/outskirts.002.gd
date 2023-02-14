extends BaseLevel

@onready var _secret_area := $tilemap/secret_area as TileMap
@onready var _tween: Tween


func _ready() -> void:
    super._ready()
    var hp = GameManager.save_data.get_map_change(biome, id, "hp_upgrade")
    if hp == "1":
        $env/health_upgrade.queue_free()

    var env := $env.get_children()
    for item in env:
        if !(item is Interactable):
            continue

        var rec = GameManager.save_data.get_map_change(biome, id, item.name)
        if rec == "1":
            (item as Interactable).disable()

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


func _on_chest_interacted(index: String) -> void:
    GameManager.save_data.push_map_change(biome, id, "chest%s" % index, "1")
