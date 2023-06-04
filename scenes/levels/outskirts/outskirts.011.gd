extends BaseLevel

@onready var _roots := $env/roots


func _ready() -> void:
    super._ready()

    var roots = GameManager.save_data.get_map_change(biome, id, "roots")
    if roots == "1":
        _roots.queue_free()
        _roots = null
