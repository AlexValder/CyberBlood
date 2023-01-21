extends Node2D
class_name BaseLevel


@onready var _spawnpoints := $spawnpoints as Node
@onready var _initial_spawn := _spawnpoints.get_node_or_null("initial") as Marker2D


func get_extends() -> Vector4i:
    return Vector4i(0, 0, 500, 500)


func setup(dict: Dictionary = {}) -> void:
    GameManager.player.set_limits(get_extends())

    if dict.has("prev_room"):
        GameManager.player.global_position = _get_spawn(dict.prev_room)
    else:
        GameManager.player.global_position = _initial_spawn.global_position


func _ready() -> void:
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

    if GameManager.last_room.length() > 0:
        setup({"prev_room" = GameManager.last_room})
    else:
        setup()


func _get_spawn(roomId: String) -> Vector2:
    assert(_spawnpoints.has_node(roomId))

    return (_spawnpoints.get_node(roomId) as Node2D).global_position
