extends BaseLevel


func _ready() -> void:
    super._ready()

    var tomb = GameManager.save_data.get_map_change(biome, id, "tomb_gate")
    if tomb == "1":
        open_tomb()


func open_tomb() -> void:
    var node := get_node_or_null("tilemap/tomb")
    if node != null:
        node.queue_free()

    var hole := get_node_or_null("env/key_hole") as KeyHole
    if hole != null:
        hole.disable()


func _on_key_hole_interacted() -> void:
    open_tomb()
    GameManager.save_data.push_map_change(biome, id, "tomb_gate", "1")
    GameManager.player.remove_item_to_inv("outskirts_tomb_key")
