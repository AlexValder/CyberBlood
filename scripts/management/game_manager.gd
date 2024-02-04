extends Node

signal debug_toggled(debug)

var _prev_state := false
var _save_index := -1
var save_data: PlayerSave

var death_screen := preload(LevelManager.DEATH_SCREEN).instantiate() as DeathScreen
var player_scene := preload("res://entities/player/player.tscn") as PackedScene
var player: Player
var camera: PlayerCamera
var debug_disabled: bool = !should_show_debug():
    set(_value):
        return
    get:
        return debug_disabled

var level_manager: LevelManager


func start_game(index: int = _save_index) -> void:
    _save_index = index
    add_player()
    get_tree().root.add_child(player)

    camera.player = player
    camera.setup_player()
    camera.enabled = true
    camera.set_process(true)
    level_manager.start_level(player, _save_index)


func reload_level() -> void:
    add_player()
    save_data.apply_player_data(player)
    level_manager.reset_last_room()
    get_tree().reload_current_scene()
    get_tree().root.add_child(player)


func save_game(save_current_room := true) -> void:
    if player == null || !level_manager.playing:
        return

    save_data.update_player_data(player)
    EnemyManager.clear_killed()

    var level := get_tree().current_scene as BaseLevel
    EnemyManager.repopulate(level)

    if save_current_room:
        save_data.map.biome = level.biome
        save_data.map.id = level.id
        save_data.map.current = level.get_save_name()

    SavesManager.save_state(_save_index, save_data)


func quit_to_menu() -> void:
    EnemyManager.clear_killed()
    remove_player()
    save_data = null
    _save_index = -1
    level_manager.quit_to_menu()


func demo_ends() -> void:
    EnemyManager.clear_killed()
    remove_player()
    level_manager.demo_ends()


func add_player() -> void:
    remove_player()

    player = player_scene.instantiate() as Player
    player.player_dead.connect(player_dies, CONNECT_ONE_SHOT)


func remove_player() -> void:
    if player:
        player.queue_free()
        player = null

    camera.set_process(false)
    camera.enabled = false
    camera.player = null


func player_dies() -> void:
    death_screen.visible = true
    death_screen.play()
    await death_screen.death_screen_done
    death_screen.visible = false

    level_manager.reset_last_room()
    EnemyManager.clear_killed()

    add_player()
    get_tree().root.add_child(player)
    camera.player = player
    camera.setup_player()
    camera.enabled = true
    camera.set_process(true)

    var biome := save_data.map.biome as String
    var id := save_data.map.id as String
    level_manager.load_level(biome, id)


func should_show_debug() -> bool:
    return Engine.is_editor_hint() || OS.is_debug_build()


func toggle_debug_info(debug: bool) -> void:
    debug_disabled = !debug
    self.debug_toggled.emit(debug)


func _ready() -> void:
    self.process_mode = Node.PROCESS_MODE_ALWAYS

    level_manager = LevelManager.new()
    add_child(level_manager)

    var camera_scene = preload("res://entities/player/player_camera.tscn")
    camera = camera_scene.instantiate() as PlayerCamera
    add_child(camera)
    death_screen.visible = false
    add_child(death_screen)

    add_player()
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
