extends Resource
class_name PlayerSave

var index := 0

var player := {
    "max_health": 0.0,
    "max_mana": 0.0,
    "inventory": [],
}
var quests := {
    "active": [],
    "for_report": [],
    "done": [],
}
var map := {
    "current" : "",
    "outskirts": [],
}

static func create_save(p: Player, level: BaseLevel) -> PlayerSave:
    var state := PlayerSave.new()

    state.player.max_health = p.max_health
    state.player.max_mana = p.max_mana
    state.player.inventory = []

    state.quests.active = []
    state.quests.for_report = []
    state.quests.done = []

    state.map = {
        "biome": level.biome,
        "id": level.id,
        "current": level.get_save_name(),
        # here will go data about how much of map is open
    }

    return state


static func from_dictionary(dict: Dictionary) -> PlayerSave:
    var state := PlayerSave.new()

    if dict.has("player"):
        state.player.max_health = dict.player.max_health
        state.player.max_mana = dict.player.max_mana
        state.player.inventory = []

    if dict.has("quests"):
        state.quests.active = []
        state.quests.for_report = []
        state.quests.done = []

    if dict.has("map"):
        state.map = dict.map

    return state


static func apply_save(state: PlayerSave, p: Player) -> void:
    p.max_health = max(state.player.max_health, p.max_health)
    p.current_health = max(state.player.max_health, p.max_health)
    p.max_mana = max(state.player.max_mana, p.max_mana)
    p.current_mana = max(state.player.max_mana, p.max_mana)


func to_dict() -> Dictionary:
    return {
        "player": player,
        "quests": quests,
        "map": map,
    }
