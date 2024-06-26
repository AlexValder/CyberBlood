extends Resource
class_name PlayerSave

var index := 0

var player := {
    "max_health": 0.0,
    "max_mana": 0.0,
    "money": 0,
    "inventory": [],
}
var quests := {
    "active": [],
    "for_report": [],
    "done": [],
}
var map := {
    "current" : "",
}


func _init() -> void:
    # populating map dict
    const levels_path := "res://scenes/levels/"
    var levels := DirAccess.get_directories_at(levels_path)
    for level in levels:
        if !level.is_empty():
            map[level] = {}


static func create_save(p: Player, level: BaseLevel) -> PlayerSave:
    var state := PlayerSave.new()

    state.player.max_health = p.max_health
    state.player.max_mana = p.max_mana
    state.player.money = p.money
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


static func apply_save(save: PlayerSave, p: Player) -> void:
    save.apply_player_data(p)


static func from_dictionary(dict: Dictionary) -> PlayerSave:
    var state := PlayerSave.new()

    if dict.has("player"):
        state.player.max_health = dict.player.max_health
        state.player.max_mana = dict.player.max_mana
        state.player.money = dict.player.money
        state.player.inventory = dict.player.inventory.duplicate()

    if dict.has("quests"):
        state.quests.active = []
        state.quests.for_report = []
        state.quests.done = []

    if dict.has("map"):
        state.map = dict.map

    return state


func push_map_change(
    biome: String, id: String, change: String, value: String) -> void:

    if !map.has(biome):
        map[biome] = {}

    if !map[biome].has(id):
        map[biome][id] = {}

    map[biome][id][change] = value


func get_map_change(biome: String, id: String, change: String) -> Variant:
    if !map.has(biome):
        return null

    if !map[biome].has(id):
        return null

    return map[biome][id].get(change)


func apply_player_data(p: Player) -> void:
    p.max_health = max(self.player.max_health, p.max_health)
    p.current_health = max(self.player.max_health, p.max_health)
    p.max_mana = max(self.player.max_mana, p.max_mana)
    p.current_mana = max(self.player.max_mana, p.max_mana)
    p.set_money(self.player.money)
    p.inventory = self.player.inventory.duplicate()


func update_player_data(p: Player) -> void:
    self.player.max_health = p.max_health
    self.player.max_mana = p.max_mana
    self.player.money = p.money
    self.player.inventory = p.inventory.duplicate()


func to_dict() -> Dictionary:
    return {
        "player": player,
        "quests": quests,
        "map": map,
    }
