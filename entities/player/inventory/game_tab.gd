extends InventoryTab

@onready var _prompt_style := $grid/prompt_style as OptionButton


func grab_gamepad_focus() -> void:
    ($grid.get_child(0) as Control).grab_focus()


func _ready() -> void:
    $grid/fps.button_pressed = Settings.get_game("show_fps")

    var style := Settings.get_game("controller_pref") as String
    var count := _prompt_style.item_count
    for i in count:
        var text := _prompt_style.get_item_text(i)
        if text.nocasecmp_to(style) == 0:
            _prompt_style.selected = i
            break


func _on_quit_button_up() -> void:
    GameManager.save_game(false)
    GameManager.quit_to_menu()


func _on_fps_toggled(button_pressed: bool) -> void:
    Settings.set_game("show_fps", button_pressed)


func _on_prompt_style_item_selected(index: int) -> void:
    var style := _prompt_style.get_item_text(index).to_lower()
    Controls.change_style(style)
