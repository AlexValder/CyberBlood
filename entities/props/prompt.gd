extends Control
class_name ButtonPrompt

@export var text := "testїєэйыąęł"
@export var action := ""

@onready var _button := $hbox/button as TextureRect
@onready var _label := $hbox/label as Label


func _ready() -> void:
    _label.text = text

    var path := Controls.get_button_path(action)
    var image = load(path)
    _button.texture = image
