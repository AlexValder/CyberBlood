extends Node2D
class_name BaseLevel

@onready var _tiles := $tilemap as TileMap
@onready var _spawnpoints := $spawnpoints as Node
@onready var _initial_spawn := _spawnpoints.get_node_or_null("initial") as Marker2D
@export var biome := ""
@export var id := ""


func get_extends() -> Vector4i:
    if _tiles == null:
        return Vector4i(0, 0, 500, 500)

    var limits := _tiles.get_used_rect() as Rect2
    var size := _tiles.tile_set.tile_size as Vector2
    var limit_left := int(limits.position.x * size.x)
    var limit_top := int(limits.position.y * size.y)
    var limit_right := int(limits.end.x * size.x)
    var limit_bottom := int(limits.end.y * size.y)

    return Vector4i(limit_left, limit_top, limit_right, limit_bottom)


func setup(dict: Dictionary = {}) -> void:
    Logger.debug("Loaded level %s" % self.name)
    GameManager.player.set_limits(get_extends())

    if dict.has("prev_room") && dict.has("entry_id"):
        GameManager.player.global_position =\
            _get_spawn(dict.prev_room, dict.entry_id)
    else:
        GameManager.player.global_position = _initial_spawn.global_position


func get_save_name() -> String:
    return "%s_%s" % [biome, id]


func _ready() -> void:
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

    if GameManager.last_room.size() > 0:
        setup({
            "prev_room" = GameManager.last_room[0],
            "entry_id" = GameManager.last_room[1],
        })
    else:
        setup()


func _get_spawn(roomId: String, entryId: String) -> Vector2:
    var node: Node2D
    if entryId == null || entryId.length() == 0:
        node = _spawnpoints.get_node(roomId)
    else:
        node = _spawnpoints.get_node("%s_%s" % [roomId, entryId])

    return node.global_position
