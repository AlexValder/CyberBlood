extends InventoryTab

@onready var _levels_options := $grid/levels_options as OptionButton


func _ready() -> void:
    _fill_up_levels()


func _fill_up_levels() -> void:
    _levels_options.clear()
    var biomes := DirAccess.get_directories_at("res://scenes/levels/")
    for biome in biomes:
        _levels_options.add_separator(biome)

        var rooms := DirAccess.get_files_at("res://scenes/levels/" + biome)
        for room in rooms:
            if room.ends_with(".remap"):
                room = room.substr(0, room.length() - 6)

            if !room.ends_with(".tscn"):
                 continue

            var room_name := room.get_file().get_basename()
            _levels_options.add_item(room_name)

    var popup := _levels_options.get_popup()
    popup.max_size.y = 100
    popup.canvas_item_default_texture_filter =\
        Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST


func _on_change_level_button_released() -> void:
    var selected_level := _levels_options.text
    var biome := selected_level.substr(0, selected_level.length() - 4)
    var id := selected_level.substr(selected_level.length() - 3)

    Logger.debug("Switch to: Biome=%s, id=%s" % [biome, id])

    GameManager.dev_change_room(biome, id)


func _on_open_folder_button_released() -> void:
    OS.shell_open(ProjectSettings.globalize_path("user://"))


func _on_open_saves_button_released() -> void:
    OS.shell_open(ProjectSettings.globalize_path("user://saves/"))


func _on_show_debug_box_toggled(button_pressed: bool) -> void:
    GameManager.toggle_debug_info(button_pressed)


func _on_save_game_button_up() -> void:
    GameManager.save_game(true, true)
