extends Node
class_name LevelManagementLastRoom

var fromId := ""
var entryId := ""
var direction := Vector2.ZERO


func init(trigger: RoomTransitionTrigger) -> void:
    fromId = trigger.fromId
    entryId = trigger.entryId
    direction = trigger.get_dir()


func is_init() -> bool:
    return !fromId.is_empty() || !entryId.is_empty()


func reset() -> void:
    fromId = ""
    entryId = ""
    direction = Vector2.ZERO
