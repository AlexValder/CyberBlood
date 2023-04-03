extends BaseLevel


func _ready() -> void:
    super._ready()
    var wall = GameManager.save_data.get_map_change(biome, id, "wall")
    if wall == "1":
        $tilemap/breakable_wall.queue_free()


func _on_breakable_wall_broken() -> void:
    GameManager.save_data.push_map_change(biome, id, "wall", "1")
