extends Node

signal debug_toggled(debug)

const LEVELS := {
    "menu": "res://scenes/ui/main_menu.tscn",
    "outskirts": "res://scenes/levels/outskirts/outskirts.000.tscn",
}
const FIRST_LEVEL := LEVELS["outskirts"]

var _playing := false
var _prev_state := false
var _save_index := -1
var save_data: PlayerSave

var player_scene := preload("res://entities/player/player.tscn") as PackedScene
var player: Player
var debug_disabled: bool = !should_show_debug():
    set(_value):
        return
    get:
        return debug_disabled
var last_room := []


func start_game(index: int) -> void:
    _save_index = index

    create_player()

    if SavesManager.save_exists(_save_index):
        save_data = SavesManager.get_save(_save_index)
        save_data.apply_player_data(player)
        var biome := save_data.map.biome as String
        var id := save_data.map.id as String

        var file_path := "res://scenes/levels/{biome}/{biome}.{id}.tscn"\
            .format({"biome" = biome, "id" = id})
        get_tree().change_scene_to_file(file_path)
    else:
        save_data = PlayerSave.new()
        save_data.update_player_data(player)
        get_tree().change_scene_to_file(FIRST_LEVEL)

    get_tree().root.add_child(player)
    _playing = true


func reload_level() -> void:
    create_player()
    last_room = []
    get_tree().reload_current_scene()
    get_tree().root.add_child(player)


func save_game(current_room := true) -> void:
    if player == null || !_playing:
        return

    save_data.update_player_data(player)

    if current_room:
        var level := get_tree().current_scene as BaseLevel
        save_data.map.biome = level.biome
        save_data.map.id = level.id
        save_data.map.current = level.get_save_name()

    SavesManager.save_state(_save_index, save_data)


func dev_change_room(biome: String, id: String) -> void:
    last_room = []

    var path := "res://scenes/levels/{biome}/{biome}.{id}.tscn".format({
        "biome" = biome,
        "id" = id,
    })

    get_tree().change_scene_to_file(path)


func change_room(trigger: RoomTransitionTrigger) -> void:
    last_room = [trigger.fromId, trigger.entryId]
    get_tree().change_scene_to_file(trigger.get_room_path())


func quit_to_menu() -> void:
    _playing = false
    remove_player()
    save_data = null
    _save_index = -1
    last_room = []
    get_tree().paused = false
    get_tree().change_scene_to_file(LEVELS["menu"])


func create_player() -> void:
    remove_player()

    player = player_scene.instantiate()
    player.player_dead.connect(player_dies, CONNECT_ONE_SHOT)


func remove_player() -> void:
    if player:
        player.queue_free()
        player = null


func player_dies() -> void:
    await get_tree().create_timer(3).timeout
    reload_level()


func should_show_debug() -> bool:
    return Engine.is_editor_hint() || OS.is_debug_build()


func toggle_debug_info(debug: bool) -> void:
    debug_disabled = !debug
    self.debug_toggled.emit(debug)


func _ready() -> void:
    self.process_mode = Node.PROCESS_MODE_ALWAYS
    create_player()
    randomize()

    _prepare_user_folder()


func _prepare_user_folder() -> void:
    DirAccess.make_dir_absolute("user://game_logs/")
    DirAccess.make_dir_absolute("user://screenshots/")
    DirAccess.make_dir_absolute("user://saves/")

    var console_logger := BloodyLogger.default_console_writer()
    console_logger.min_level = BloodyLogger.DEBUG
    Logger.add_writer(console_logger)
    if !OS.is_debug_build():
        var logger \
            := BloodyLogger.default_error_file_writer("user://game_logs/error")
        Logger.add_writer(logger)


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_released("screenshot"):
        var image := get_viewport().get_texture().get_image()
        var path := _get_screenshot_path()
        image.save_png(path)


func _notification(what: int) -> void:
    match what:
        NOTIFICATION_APPLICATION_FOCUS_OUT:
            if Engine.is_editor_hint():
                return

            _prev_state = get_tree().paused
            get_tree().paused = true
        NOTIFICATION_APPLICATION_FOCUS_IN:
            if Engine.is_editor_hint():
                return

            get_tree().paused = _prev_state


func _get_screenshot_path() -> String:
    const template :=\
        "user://screenshots/screenshot-%f.png"
    var time := Time.get_unix_time_from_system()

    return template % time
