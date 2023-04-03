extends BaseLevel


func _ready() -> void:
    super._ready()
    # TODO: key should only be spawn after bossfight
    var key = GameManager.save_data.get_map_change(
        biome, id, "outskirts_tomb_key")
    if key == "1":
        $env/key_00.queue_free()
