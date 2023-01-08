extends Node


const LEVELS := {
    "menu": "res://scenes/main_menu.tscn",
    "test": "res://scenes/levels/test_level.tscn",
}

var _playing := false
var _prev_state := false

var player := preload("res://entities/player/player.tscn") \
    .instantiate() as Player


func start_game() -> void:
    get_tree().change_scene_to_file(LEVELS["test"])
    _playing = true


func reload_level() -> void:
    get_tree().reload_current_scene()


func quit_to_menu() -> void:
    _playing = false
    get_tree().paused = false
    get_tree().change_scene_to_file(LEVELS["menu"])


func _ready() -> void:
    self.process_mode = Node.PROCESS_MODE_ALWAYS


func _notification(what: int) -> void:
    match (what):
        NOTIFICATION_APPLICATION_FOCUS_OUT:
            _prev_state = get_tree().paused
            get_tree().paused = true
        NOTIFICATION_APPLICATION_FOCUS_IN:
            get_tree().paused = _prev_state
