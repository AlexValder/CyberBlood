extends Control
class_name ButtonPrompt

@export var text := "testїєэйыąęł"
@export var action := ""
@onready var _button := $hbox/button as TextureRect
@onready var _label := $hbox/label as Label


func load_image(path: String, button: TextureRect) -> void:
    var image = load(path)
    button.texture = image


func set_text(txt: String) -> void:
    _label.text = txt


func _setup() -> void:
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


func _ready() -> void:
    Controls.input_changed.connect(_change_input)

    set_text(text)
    _setup()


func _change_input() -> void:
    var children := $hbox.get_children()
    for child in children:
        if child != _button && child != _label:
            child.queue_free()

    _setup()
