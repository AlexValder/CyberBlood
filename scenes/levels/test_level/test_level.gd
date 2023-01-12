extends BaseLevel

@onready var _tiles := $tilemap as TileMap


func get_extends() -> Vector4i:
    var limits := _tiles.get_used_rect() as Rect2
    var size := _tiles.tile_set.tile_size as Vector2
    var limit_left := int(limits.position.x * size.x)
    var limit_top := int(limits.position.y * size.y)
    var limit_right := int(limits.end.x * size.x)
    var limit_bottom := int(limits.end.y * size.y)

    return Vector4i(limit_left, limit_top - 500, limit_right, limit_bottom)


func _ready() -> void:
    super._ready()
    spawnpoints.append($spawnpoint)

    GameManager.player.global_position = spawnpoints[0].global_position
    GameManager.player.set_limits(get_extends())
