extends CanvasLayer

const CHAR_READ_RATE = 0.1

onready var textbox_container = $TextboxContainer
onready var label = $TextboxContainer/MarginContainer/HBoxContainer/Label

enum State {READY, READING, FINISHED}
var current_state = State.READY
signal conversation_start
signal conversation_end

var textbox = []

func _ready():
	hide_textbox()

func _process(delta):
		match current_state:
			State.READY:
				if !textbox.empty():
					emit_signal("conversation_start")
					display_text()
				else: 
					emit_signal("conversation_end")
			State.READING:
				pass
			State.FINISHED:
				if Input.is_action_just_pressed('ui_select'):
					change_state(State.READY)
					if textbox.empty():
						hide_textbox()

func hide_textbox():
	label.text = ""
	textbox_container.hide()
	
func show_textbox():
	textbox_container.show()

func display_text():
	var next_text = textbox.pop_front()
	label.text = next_text
	label.percent_visible = 0.0
	change_state(State.READING)
	$Tween.interpolate_property(label, "percent_visible", 0.0, 1.0, len(next_text)*CHAR_READ_RATE, Tween.TRANS_LINEAR)
	$Tween.start()
	show_textbox()
	
func _on_Tween_tween_all_completed():
	change_state(State.FINISHED)
	
func change_state(next_state):
	current_state = next_state
	match current_state:
		State.READY:
			pass
		State.READING:
			pass
		State.FINISHED:
			if Input.is_action_just_pressed('ui_select'):
				change_state(State.READY)
				if textbox.empty():
					hide_textbox()
	
func _on_Player_talk():
	textbox = ["Tämä on lumikasa.", "No niin ilmeisesti on!"]
