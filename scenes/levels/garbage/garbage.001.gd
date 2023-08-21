extends BaseLevel

@onready var _door := $env/bg_door as BgDoor


func get_extends() -> Vector4i:
    var vector := super.get_extends()
    vector[1] = -10_000

    return vector


func _ready() -> void:
    super._ready()

    var door = GameManager.save_data.get_map_change(
        biome, id, "research_lab_unlocked")
    if door == "1":
        _door.unlock()


func _on_research_lab_door_unlocked() -> void:
    GameManager.save_data.push_map_change(
        biome, id, "research_lab_unlocked", "1")
