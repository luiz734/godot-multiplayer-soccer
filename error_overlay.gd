extends ColorRect
class_name ErrorOverlay

func _process(delta):
    if Input.is_action_just_pressed("click"):
        self.visible = false

func show_error(msg: String):
    visible = true
    %ErrorMessage.text = msg
