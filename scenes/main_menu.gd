extends Control
class_name MainMenu


func _ready() -> void:
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
    $"%play".grab_focus()
    $version.text =\
        "v%s" % ProjectSettings.get_setting("application/config/version")


func _on_play_button_up() -> void:
    GameManager.start_game()


func _on_quit_button_up() -> void:
    get_tree().quit()
