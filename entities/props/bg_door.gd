extends RoomTransitionTrigger
class_name BgDoor

signal unlocked

@export var locked := false
@export var key_id := ""

@onready var _key_hole := $key_hole as KeyHole
@onready var _prompt := $prompt_area/prompt as ButtonPrompt
@onready var _shape := $interactable/shape as CollisionShape2D


func interact() -> void:
    GameManager.level_manager.change_room(self)


func _ready() -> void:
    fromId = owner.name
    _key_hole.key_id = key_id
    if locked:
        assert(!key_id.is_empty())
        _shape.disabled = true
        _prompt.set_text("unlock")
    else:
        _key_hole.queue_free()


func _on_body_entered(_node: Node2D) -> void:
    pass


func unlock() -> void:
    if !locked:
        return

    GameManager.player.remove_item_to_inv(key_id)
    unlocked.emit()

    locked = false

    _shape.disabled = false
    _prompt.set_text("enter")
    if _key_hole != null:
        _key_hole.queue_free()
        _key_hole = null
