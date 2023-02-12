extends VBoxContainer
class_name SavesMenu

@onready var _panels: Array[Control] = [
    $grid/panel_00/vbox as Control,
    $grid/panel_01/vbox as Control,
    $grid/panel_02/vbox as Control,
    $grid/panel_03/vbox as Control,
]
@onready var _buttons: Array[Button] = [
    $grid/hbox_00/button as Button,
    $grid/hbox_01/button as Button,
    $grid/hbox_02/button as Button,
    $grid/hbox_03/button as Button,
]


func _ready() -> void:
    _populate_panels()
    _setup_buttons()


func _populate_panels() -> void:
    var count := SavesManager.SAVE_COUNT # currently 4

    for i in count:
        var dict := SavesManager.get_save_meta(i)
        var place := _panels[i].get_node("last_place") as Label
        var time := _panels[i].get_node("last_time") as Label
        var percent := _panels[i].get_node("percentage") as Label

        place.text = dict.get("last_place", "").capitalize()
        time.text = dict.get("last_time", "<EMPTY>")
        percent.text = dict.get("percentage", "")


func _setup_buttons() -> void:
    var count := SavesManager.SAVE_COUNT

    for i in count:
        var button := _buttons[i]
        button.text = "Save %d" % (i + 1)
        button.button_up.connect(GameManager.start_game.bind(i))

        (get_node("grid/hbox_0%d/del" % i) as Button)\
            .button_up.connect(_clear_save.bind(i))


func _clear_save(index: int) -> void:
    SavesManager.remove_save_file(index)

    var place := _panels[index].get_node("last_place") as Label
    var time := _panels[index].get_node("last_time") as Label
    var percent := _panels[index].get_node("percentage") as Label

    place.text = ""
    time.text = "<EMPTY>"
    percent.text = ""
