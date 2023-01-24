extends Node


const LEVELS := {
    "menu": "res://scenes/main_menu.tscn",
    "test": {
        "001": "res://scenes/levels/test_level/test_level.001.tscn",
        "002": "res://scenes/levels/test_level/test_level.002.tscn",
    },
}
const FIRST_LEVEL := LEVELS["test"]["001"]

var _playing := false
var _prev_state := false

var player_scene := preload("res://entities/player/player.tscn") as PackedScene
var player: Player
var last_room := ""


func start_game() -> void:
    get_tree().change_scene_to_file(FIRST_LEVEL)
    create_player()
    get_tree().root.add_child(player)
    _playing = true


func reload_level() -> void:
    create_player()
    last_room = ""
    get_tree().reload_current_scene()
    get_tree().root.add_child(player)


func change_room(trigger: RoomTransitionTrigger) -> void:
    last_room = trigger.fromId
    get_tree().change_scene_to_file(trigger.get_room_path())


func quit_to_menu() -> void:
    _playing = false
    remove_player()
    last_room = ""
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


func _ready() -> void:
    self.process_mode = Node.PROCESS_MODE_ALWAYS
    create_player()
    randomize()

    var console_logger := BloodyLogger.default_console_writer()
    console_logger.min_level = BloodyLogger.DEBUG
    Logger.add_writer(console_logger)
    if !OS.is_debug_build():
        var logger := BloodyLogger.default_error_file_writer()
        logger.filename = "user://logs/error"
        Logger.add_writer(logger)


func player_dies() -> void:
    await get_tree().create_timer(3).timeout
    reload_level()


func _notification(what: int) -> void:
    if Engine.is_editor_hint():
        return

    match what:
        NOTIFICATION_APPLICATION_FOCUS_OUT:
            _prev_state = get_tree().paused
            get_tree().paused = true
        NOTIFICATION_APPLICATION_FOCUS_IN:
            get_tree().paused = _prev_state
