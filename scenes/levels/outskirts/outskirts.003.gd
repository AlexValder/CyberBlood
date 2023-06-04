extends BaseLevel

@onready var _trapdoor := $env/trap_door
@onready var _hiding := $tilemap/hide
@onready var _hidden_area := $env/hide_corridor
@onready var _bottom_arena := $tilemap/bottom
@onready var _breakable_floor := $env/breakable_floor


func _ready() -> void:
    super._ready()

    var shortcut = GameManager.save_data.get_map_change(biome, id, "shortcut")
    if shortcut == "1":
        _trapdoor.queue_free()
        _trapdoor = null
        _hidden_area.queue_free()
        _hidden_area = null
        _hiding.queue_free()
        _hiding = null

    var fight = GameManager.save_data.get_map_change(biome, id, "fight_over")
    if fight == "1":
        clear_arena()


func clear_arena() -> void:
    if _bottom_arena == null: return
    if _breakable_floor == null: return

    _bottom_arena.queue_free()
    _bottom_arena = null
    _breakable_floor.queue_free()
    _breakable_floor = null


func _on_lever_interacted() -> void:
    if _trapdoor != null:
        _trapdoor.queue_free()
        _trapdoor = null

    if _hidden_area != null:
        _hidden_area.queue_free()
        _hidden_area = null

    if _hiding != null:
        _hiding.queue_free()
        _hiding = null

    GameManager.save_data.push_map_change(biome, id, "shortcut", "1")


func _on_fight_completed() -> void:
    GameManager.save_data.push_map_change(biome, id, "fight_over", "1")
    clear_arena()
