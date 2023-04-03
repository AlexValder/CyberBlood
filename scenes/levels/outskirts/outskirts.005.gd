extends BaseLevel

@onready var _roots := $tilemap/roots
@onready var _floor := $env/floor
@onready var _shortcut := $env/breakable_floor
@onready var _chain := $env/bell/chain
@onready var _bell := $env/bell
@onready var _door := $env/door

const BELL_END := 960


func _ready() -> void:
    super._ready()

    var roots = GameManager.save_data.get_map_change(biome, id, "roots")
    if roots == "1":
        _roots.queue_free()

    var shortcut = GameManager.save_data.get_map_change(biome, id, "shortcut")
    if shortcut == "1":
        _shortcut.queue_free()

    var floor = GameManager.save_data.get_map_change(biome, id, "floor")
    if floor == "1":
        _chain.queue_free()
        _floor.queue_free()
        _bell.position.y = BELL_END

    var door = GameManager.save_data.get_map_change(biome, id, "door")
    if door == "1":
        _door.queue_free()


func _on_breakable_floor_broken() -> void:
    GameManager.save_data.push_map_change(biome, id, "shortcut", "1")


func _on_chain_broken() -> void:
    GameManager.save_data.push_map_change(biome, id, "floor", "1")
    _chain.queue_free()

    var tween := create_tween()
    tween.tween_property(_bell, "position:y", BELL_END, 1.5)\
        .set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
    tween.play()
    _floor.queue_free()


func _on_door_interacted() -> void:
    GameManager.save_data.push_map_change(biome, id, "door", "1")
