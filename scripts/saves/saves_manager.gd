extends Node
class_name SavesManager

const PATH := "user://saves/save_%d.save"
const SAVE_COUNT := 4


static func save_exists(index: int) -> bool:
    return FileAccess.file_exists(PATH % index)


static func get_all_save_data() -> Array[Dictionary]:
    var arr := []

    for i in SAVE_COUNT:
        var dict := get_save_meta(i)
        arr.append(dict)

    return arr


static func get_save(index: int) -> PlayerSave:
    var file_path := PATH % index
    if !FileAccess.file_exists(file_path):
        var f := FileAccess.open(file_path, FileAccess.WRITE)
        f.store_string("{}")

    var file := FileAccess.open(file_path, FileAccess.READ)
    var raw_json := file.get_as_text()
    var dict = JSON.parse_string(raw_json) as Dictionary
    return PlayerSave.from_dictionary(dict)


static func get_save_meta(index: int) -> Dictionary:
    Logger.debug("Getting metadata for save %d" % index)

    var dict := {}
    var path := PATH % index
    if !FileAccess.file_exists(path):
        return dict

    var file := FileAccess.open(path, FileAccess.READ)
    var raw_json := file.get_as_text()
    var save_dict := JSON.parse_string(raw_json) as Dictionary

    dict["last_place"] = save_dict["map"]["current"]

    var unix := FileAccess.get_modified_time(path)
    var time := Time.get_date_string_from_unix_time(unix) +\
        " " + Time.get_time_string_from_unix_time(unix)
    dict["last_time"] = time

    dict["percentage"] = "0%"

    return dict


static func save_state(index: int, save: PlayerSave) -> void:
    Logger.debug("Saved state %d" % index)

    var string := JSON.stringify(save.to_dict(), "  ")
    var file_path := PATH % index
    if !FileAccess.file_exists(file_path):
        FileAccess.open(file_path, FileAccess.WRITE)

    var file := FileAccess.open(file_path, FileAccess.READ_WRITE)
    file.store_string(string)
    file.flush()


static func create_save(index: int, player: Player, level: BaseLevel) -> void:
    var save := PlayerSave.create_save(player, level)
    save_state(index, save)


static func load_state(index: int, player: Player) -> void:
    Logger.debug("Loaded state %d" % index)
    PlayerSave.apply_save(get_save(index), player)


static func remove_save_file(index: int) -> void:
    Logger.debug("Removing save file #%d" % index)

    var path := OS.get_user_data_dir() + "/saves/save_%d.save" % index

    if FileAccess.file_exists(path):
        OS.move_to_trash(path)
