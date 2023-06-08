extends Control
class_name CommandLine

@onready var inputString : LineEdit = get_node("/root/CommandLine/Window/vBoxContainer/lineEdit")
@onready var RichTextLabelWindow : RichTextLabel = get_node("/root/CommandLine/Window/vBoxContainer/richTextLabel")
#@onready var mouseInput := Input.mouse_mode

enum ConsoleFunctions {
    EXCEPTION,
    PRINT,
    CLEAR
}

func _ready():
    self.visible = false


func _process(delta):
    pass


func _input(_event):
    if Input.is_action_just_pressed("~"):
        self.visible = !self.visible
        if self.visible:
            inputString.grab_focus()
            get_tree().get_root().set_input_as_handled()
            self.accept_event()
        else:
            inputString.release_focus()



func getFunction(input: String) -> Array:
    input = input.lstrip(" ").rstrip(" ")
    var wordsArr = input.split(" ", true, 1)
    match wordsArr[0].to_lower():
        "print":
            wordsArr[0] = str(ConsoleFunctions.PRINT)
        "clear":
            wordsArr[0] = str(ConsoleFunctions.CLEAR)
        _:
            badCommandMsg(wordsArr[0])
            wordsArr[0] = str(ConsoleFunctions.EXCEPTION)
    return wordsArr


func runFunction(inputArray: Array) -> void:
    match (inputArray[0].to_int()):
        ConsoleFunctions.EXCEPTION:
            pass
        ConsoleFunctions.PRINT:
            if (
                    inputArray.size() != 1
                    and inputArray[1].begins_with('"')
                    and inputArray[1].ends_with('"')
            ):
                inputArray[1] = inputArray[1].trim_prefix('"')\
                        .trim_suffix('"')
                consolePrint(inputArray[1])
            else:
                consolePrint("No arguments in \"PRINT\" or wrong format of arguments.\n"+\
                        "Please enter the text and enclose it in "+\
                        "double quotation marks on both sides.")
        ConsoleFunctions.CLEAR:
            consoleClear()


func consolePrint(printString: String) -> void:
    RichTextLabelWindow.add_text(printString)
    RichTextLabelWindow.newline()


func consoleClear() -> void:
    RichTextLabelWindow.clear()


func badCommandMsg(cmd : String) -> void:
    consolePrint("Function \"" + cmd + "\" does not exist")


func _on_line_edit_text_submitted(new_text):
    runFunction(getFunction(new_text))
    inputString.clear()
