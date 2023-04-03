extends InventoryTab


func grab_gamepad_focus() -> void:
    ($grid.get_child(0) as Control).grab_focus()


func _ready() -> void:
    $grid/fps.button_pressed = Settings.get_game("show_fps")


func _on_quit_button_up() -> void:
    GameManager.save_game(false)
    GameManager.quit_to_menu()


func _on_fps_toggled(button_pressed: bool) -> void:
    Settings.set_game("show_fps", button_pressed)
