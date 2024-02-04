extends Node
class_name LevelManager

const LEVELS := {
    "menu": "res://scenes/ui/main_menu.tscn",
    "game": "res://scenes/levels/{biome}/{biome}.{id}.tscn",
    "demo_end": "res://scenes/ui/end_demo_screen.tscn",
}
const DEATH_SCREEN := "res://scenes/ui/death_screen.tscn"
const FIRST_LEVEL_FORMAT := {"biome" = "garbage", "id" = "000"}
const FRESH_SAVE_NAME := "Start level"

var playing := false
var last_room: LevelManagementLastRoom


func start_level(player: Player, index: int) -> void:
    var level: String
    if SavesManager.save_exists(index):
        GameManager.save_data = SavesManager.get_save(index)
        GameManager.save_data.apply_player_data(player)
        var biome := GameManager.save_data.map.biome as String
        var id := GameManager.save_data.map.id as String

        level = LEVELS["game"].format({"biome" = biome, "id" = id})
    else:
        GameManager.save_data = PlayerSave.new()
        GameManager.save_data.update_player_data(player)
        level = LEVELS["game"].format(FIRST_LEVEL_FORMAT)
        GameManager.save_data.map.biome = FIRST_LEVEL_FORMAT.biome
        GameManager.save_data.map.id = FIRST_LEVEL_FORMAT.id
        GameManager.save_data.map.current = FRESH_SAVE_NAME

    playing = true
    get_tree().change_scene_to_file(level)


func load_level(biome: String, id: String) -> void:
    var level = LEVELS["game"].format({"biome" = biome, "id" = id})
    get_tree().change_scene_to_file(level)


func change_room(trigger: RoomTransitionTrigger) -> void:
    last_room.init(trigger)
    get_tree().change_scene_to_file(trigger.get_room_path())


func dev_change_room(biome: String, id: String) -> void:
    last_room.reset()

    var path := "res://scenes/levels/{biome}/{biome}.{id}.tscn".format({
        "biome" = biome,
        "id" = id,
    })
    get_tree().change_scene_to_file(path)


func reset_last_room() -> void:
    last_room.reset()


func has_last_room() -> bool:
    return last_room.is_init()


func demo_ends() -> void:
    quit_to_menu("demo_end")


func quit_to_menu(level := "menu") -> void:
    last_room.reset()
    playing = false
    get_tree().paused = false
    get_tree().change_scene_to_file(LEVELS[level])


func _ready() -> void:
    last_room = LevelManagementLastRoom.new()
