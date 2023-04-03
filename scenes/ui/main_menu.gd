extends Control
class_name MainMenu

@onready var _play := $"%play" as Button
@onready var _main := $main as Control
@onready var _saves := $saves as Control


func _ready() -> void:
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

    _main.visible = true
    _saves.visible = false
    _play.grab_focus()
    $version.text =\
        "v%s" % ProjectSettings.get_setting("application/config/version")


func _on_play_button_up() -> void:
    _main.visible = false
    _saves.visible = true


func _on_quit_button_up() -> void:
    get_tree().quit()


func _on_back_button_up() -> void:
    _main.visible = true
    _saves.visible = false
