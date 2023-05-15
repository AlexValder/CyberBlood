extends Area2D
class_name RoomTransitionTrigger

enum DIRECTION {
    Up, Down, Left, Right
}

## ID of a biome
@export var biome: String
## short ID of a room - unique per biome
@export var roomId: String
## if there are multiple entries to the room, set this
@export var entryId: String = ""
## from which side we enter
@export var direction := DIRECTION.Left
## assumes scene root name is something like "biome_xxx",
## where xxx is room id.
@onready var fromId: String = owner.name


func get_room_path() -> String:
    return "res://scenes/levels/{biome}/{biome}.{id}.tscn".format({
        "biome" = biome,
        "id" = roomId,
    })


func get_dir() -> Vector2:
    match (self.direction):
        DIRECTION.Up:
            return Vector2.UP
        DIRECTION.Down:
            return Vector2.DOWN
        DIRECTION.Left:
            return Vector2.LEFT
        DIRECTION.Right:
            return Vector2.RIGHT
        _:
            push_error("Unknown direction: %d" % self.direction)

    return Vector2.ZERO


func _init() -> void:
    self.collision_mask = 2
    self.collision_layer = 0

    self.body_entered.connect(_on_body_entered)


func _on_body_entered(_node: Node2D) -> void:
    GameManager.call_deferred("change_room", self)
