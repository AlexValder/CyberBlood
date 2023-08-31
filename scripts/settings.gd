extends Node

const FILE_NAME := "user://settings.ini"
const DEFAULTS := {
    "game" = {
        "show_fps" = true,
        "controller_pref" = "xbox",
        "version" = "0.0.0.2",
    },
    "graphics" = {
        "fullscreen" = true,
        "vsync" = true,
    },
}

@onready var _config := ConfigFile.new()
var _settings := {}


func get_game(key: String) -> Variant:
    return _get_value("game", key)


func get_graphics(key: String) -> Variant:
    return _get_value("graphics", key)


func set_game(key: String, value: Variant) -> void:
    _set_value("game", key, value)


func set_graphics(key: String, value: Variant) -> void:
    _set_value("graphics", key, value)


func _get_value(section: String, key: String) -> Variant:
    return _config.get_value(section, key)


func _set_value(section: String, key: String, value: Variant) -> void:
    if !_config.has_section(section):
        push_error("No section: %s" % section)

    if !_config.has_section_key(section, key):
        push_error("No key %s in %s" % [key, section])

    _config.set_value(section, key, value)
    _settings.game[key] = value
    _config.save(FILE_NAME)


func _set_defaults() -> void:
    _settings.clear()
    _config.clear()

    for section in DEFAULTS:
        if !_settings.has(section):
            _settings[section] = {}

        for key in DEFAULTS[section]:
            if !_settings[section].has(key):
                _settings[section][key] = {}

            _settings[section][key] = DEFAULTS[section][key]
            _config.set_value(section, key, DEFAULTS[section][key])

    _config.save(FILE_NAME)


func _save_settings() -> void:
    for section in DEFAULTS:
        for key in DEFAULTS[section]:
            _config.set_value(section, key, _settings[section][key])

    _config.save(FILE_NAME)


func _load_settings() -> void:
    if _config.get_value("game", "version", null) != DEFAULTS["game"]["version"]:
        # outdated, fuck it
        Logger.warn("Version in config file is either absent or doesn't match")
        _set_defaults()
        return

    for section in DEFAULTS:
        if !_settings.has(section):
            _settings[section] = {}
        for key in DEFAULTS[section]:
            if !_settings[section].has(key):
                _settings[section][key] = {}

            if _config.has_section_key(section, key):
                _settings[section][key] = _config.get_value(section, key)
            else:
                _settings[section][key] = DEFAULTS[section][key]

    _config.save(FILE_NAME)


func _ready() -> void:
    if !FileAccess.file_exists(FILE_NAME):
        FileAccess.open(FILE_NAME, FileAccess.WRITE)
        _set_defaults()

    var error := _config.load(FILE_NAME)
    if error != OK:
        push_error("Failed to load file: %d" % error)

    _load_settings()
