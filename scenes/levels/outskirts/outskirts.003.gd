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
        _hidden_area.queue_free()
        _hiding.queue_free()

    var fight = GameManager.save_data.get_map_change(biome, id, "fight_over")
    if fight == "1":
        clear_arena()


func clear_arena() -> void:
    _bottom_arena.queue_free()
    _breakable_floor.queue_free()


func _on_lever_interacted() -> void:
    _trapdoor.queue_free()
    _hidden_area.queue_free()
    _hiding.queue_free()
    GameManager.save_data.push_map_change(biome, id, "shortcut", "1")


func _on_fight_completed() -> void:
    GameManager.save_data.push_map_change(biome, id, "fight_over", "1")
    clear_arena()
