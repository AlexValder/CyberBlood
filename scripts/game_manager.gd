extends Node


const LEVELS := {
    "menu": "res://scenes/main_menu.tscn",
    "test": "res://scenes/levels/test_level/test_level.tscn",
}

var _playing := false
var _prev_state := false

var player_scene := preload("res://entities/player/player.tscn") as PackedScene
var player: Player


func start_game() -> void:
    get_tree().change_scene_to_file(LEVELS["test"])
    create_player()
    get_tree().root.add_child(player)
    _playing = true


func reload_level() -> void:
    create_player()
    get_tree().reload_current_scene()
    get_tree().root.add_child(player)


func quit_to_menu() -> void:
    _playing = false
    remove_player()
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


func player_dies() -> void:
    await get_tree().create_timer(3).timeout
    reload_level()


func _notification(what: int) -> void:
    match (what):
        NOTIFICATION_APPLICATION_FOCUS_OUT:
            _prev_state = get_tree().paused
            get_tree().paused = true
        NOTIFICATION_APPLICATION_FOCUS_IN:
            get_tree().paused = _prev_state
