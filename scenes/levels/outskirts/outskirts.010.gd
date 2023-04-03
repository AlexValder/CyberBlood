extends BaseLevel


func _ready() -> void:
    super._ready()

    # TODO: key should only be spawn after quest completion
    var key = GameManager.save_data.get_map_change(
        biome, id, "outskirts_gate_key")
    if key == "1":
        $env/key_00.queue_free()


func _on_debug_open_roots_body_entered() -> void:
    GameManager.save_data.push_map_change(biome, "011", "roots", "1")
    GameManager.save_data.push_map_change(biome, "005", "roots", "1")
