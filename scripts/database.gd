extends Node

const _DB_PATH := "res://data/sqlite.db"
var db


func get_item_by_name(item_name: String) -> Array:
    return get_item("name", item_name)


func get_item_by_path(path: String) -> Array:
    return get_item("path", path)


func get_item_by_id(id: int) -> Array:
    return get_item("id", str(id))


func get_item(key: String, value: String) -> Array:
    return _get_from_database("inventory_items", "%s LIKE '%s'" % [key, value])


func _enter_tree() -> void:
    _load_db()


func _exit_tree() -> void:
    db.close_db()


func _load_db() -> void:
    db = SQLite.new()
    db.path = _DB_PATH
    db.verbosity_level = 2 if OS.is_debug_build() else 0
    db.read_only = true

    if !db.open_db():
        push_error("Failed to open database")


func _get_from_database(table: String, selector := "", rows := ["*"]) -> Array:
    return [] + db.select_rows(table, selector, rows)
