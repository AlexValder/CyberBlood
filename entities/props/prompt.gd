extends Control
class_name ButtonPrompt

@export var text := "testїєэйыąęł"
@export var action := ""
@onready var _button := $hbox/button as TextureRect
@onready var _label := $hbox/label as Label


func _ready() -> void:
    set_text(text)
    if !action.contains("+"):
        load_image(Controls.get_button_path(action), _button)
    else:
        var paths := Controls.get_multiple_paths(action)
        load_image(paths[0], _button)

        var s := paths.size()
        for i in s - 1:
            var plus := _label.duplicate(Node.DUPLICATE_USE_INSTANTIATION)\
                as Label
            plus.text = "+"
            _button.add_sibling(plus)

            var b := _button.duplicate(Node.DUPLICATE_USE_INSTANTIATION)\
                as TextureRect
            plus.add_sibling(b)
            load_image(paths[i + 1], b)


func load_image(path: String, button: TextureRect) -> void:
    var image = load(path)
    button.texture = image


func set_text(txt: String) -> void:
    _label.text = txt
