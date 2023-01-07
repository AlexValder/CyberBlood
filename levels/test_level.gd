extends Node2D
class_name BaseLevel

@onready var _tiles := $tilemap as TileMap
@onready var _player := $player as Player


func _ready() -> void:
    _player.set_limits(get_extends())


func get_extends() -> Vector4:
    var limits := _tiles.get_used_rect() as Rect2
    var size := _tiles.tile_set.tile_size as Vector2
    var limit_left := limits.position.x * size.x
    var limit_top := limits.position.y * size.y
    var limit_right := limits.end.x * size.x
    var limit_bottom := limits.end.y * size.y

    return Vector4(limit_left, limit_top - 500, limit_right, limit_bottom)
