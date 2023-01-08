extends Control
class_name MainMenu


func _ready() -> void:
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
    $"%play".grab_focus()


func _on_play_button_up() -> void:
    GameManager.start_game()


func _on_quit_button_up() -> void:
    get_tree().quit()
