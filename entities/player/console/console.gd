extends Control

var LineEditString : LineEdit = null
var RichTextLabelWindow : RichTextLabel = null

enum ConsoleFunctions {
    PRINT,
    CLEAR,
}


func _ready():
    LineEditString = $ConsoleWindow/lineEdit
    RichTextLabelWindow = $ConsoleWindow/richTextLabel
    $ConsoleWindow.visible = false
    Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
    
# Called when the node enters the scene tree for the first time.
func _input(event):
    if Input.is_action_just_pressed("~"):
        $ConsoleWindow.visible = !$ConsoleWindow.visible
        if $ConsoleWindow.visible:
            Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
        else:
            Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func getFunction(inputString: String) -> Array:
    inputString = inputString.lstrip(" ").rstrip(" ")
    var wordsArr = inputString.split(" ", true, 1)
    match wordsArr[0].to_lower():
        "print":
            wordsArr[0] = str(ConsoleFunctions.PRINT)
        "clear":
            wordsArr[0] = str(ConsoleFunctions.CLEAR)
        _:
            consolePrint("Function \""
                    + wordsArr[0] + "\" does not exist")
            wordsArr[0] = str(-1)
    return wordsArr


func runFunction(inputArray: Array) -> void:
    var argsArr: Array = []
    match (inputArray[0].to_int()):
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


func _on_line_edit_text_submitted(new_text):
    print(new_text) # Replace with function body.
    runFunction(getFunction(new_text))
#    RichTextLabelWindow.newline()
    LineEditString.clear()
