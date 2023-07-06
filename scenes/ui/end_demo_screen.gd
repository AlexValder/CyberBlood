extends Control


func _ready() -> void:
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
    $%continue.grab_focus()


func _on_socials_button_up(url: String) -> void:
    OS.shell_open(url)


func _on_continue_button_up() -> void:
    GameManager.start_game()


func _on_quit_button_up() -> void:
    GameManager.quit_to_menu()
