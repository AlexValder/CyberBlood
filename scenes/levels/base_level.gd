extends Node2D
class_name BaseLevel

@export var biome := ""
@export var id := ""

@onready var _tiles := $tilemap as TileMap
@onready var _spawnpoints := $spawnpoints as Node
@onready var _initial_spawn :=\
    _spawnpoints.get_node_or_null("initial") as Marker2D

var _tween: Tween


func get_extends() -> Vector4i:
    if _tiles == null:
        return Vector4i(0, 0, 500, 500)

    var limits := _tiles.get_used_rect() as Rect2
    var size := _tiles.tile_set.tile_size as Vector2
    var offset := _tiles.global_position
    var limit_left := int(limits.position.x * size.x) + int(offset.x)
    var limit_top := int(limits.position.y * size.y) + int(offset.y)
    var limit_right := int(limits.end.x * size.x) + int(offset.x)
    var limit_bottom := int(limits.end.y * size.y) + int(offset.y)

    return Vector4i(limit_left, limit_top, limit_right, limit_bottom)


func get_save_name() -> String:
    return "%s_%s" % [biome, id]


func collect_interactables() -> void:
    var env := get_node_or_null("env")
    if env == null:
        return

    var children := env.get_children()
    for item in children:
        var inter := item as Interactable
        if inter == null:
            continue

        var rec = GameManager.save_data.get_map_change(biome, id, inter.name)
        var iname: String
        var index: String
        if rec == "1":
            inter.disable()
        elif inter.name.begins_with("chest") \
            || inter.name.begins_with("lever"):
            iname = inter.name.substr(0, 5)
            index = inter.name.substr(5)

        inter.interacted.connect(_on_prop_interacted.bind(iname, index))


func _ready() -> void:
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    Logger.debug("Loaded level %s" % self.name)
    GameManager.player.set_limits(get_extends())
    GameManager.player.disable_collision()

    var spawn: Vector2
    if GameManager.last_room.size() > 0:
        spawn = _get_spawn(GameManager.last_room[0], GameManager.last_room[1])
    else:
        spawn = _initial_spawn.global_position
    GameManager.player.global_position = spawn
    GameManager.player.enable_collision()

    collect_interactables()


func _get_spawn(roomId: String, entryId: String) -> Vector2:
    var node: Node2D
    if entryId == null || entryId.length() == 0:
        node = _spawnpoints.get_node(roomId)
    else:
        node = _spawnpoints.get_node("%s_%s" % [roomId, entryId])

    return node.global_position


func _on_prop_interacted(iname: String, index: String) -> void:
    GameManager.save_data.push_map_change(
        biome, id, "%s%s" % [iname, index], "1")


func _on_key_picked_up(key_id: String) -> void:
    GameManager.save_data.push_map_change(biome, id, key_id, "1")


func _on_corridor_hide_body_entered(player: Player, path: NodePath) -> void:
    if player == null || path == null:
        return

    if _tween:
        _tween.kill()
    _tween = create_tween()
    _tween.tween_property(get_node(path), "modulate:a", 0.0, 0.5)


func _on_corridor_hide_body_exited(player: Player, path: NodePath) -> void:
    if player == null || path == null:
        return

    if _tween:
        _tween.kill()
    _tween = create_tween()
    _tween.tween_property(get_node(path), "modulate:a", 1.0, 0.5)
