extends Area2D
class_name RoomTransitionTrigger

@export var biome: String
@export var roomId: String
## assumes scene root name is something like "biome_xxx",
## where xxx is room id.
@onready var fromId: String = owner.name


func get_room_path() -> String:
    return "res://scenes/levels/{biome}/{biome}.{id}.tscn".format({
        "biome" = biome,
        "id" = roomId,
    })


func _init() -> void:
    self.collision_mask = 2
    self.collision_layer = 0

    self.body_entered.connect(_on_body_entered)


func _on_body_entered(_node: Node2D) -> void:
    GameManager.call_deferred("change_room", self)
