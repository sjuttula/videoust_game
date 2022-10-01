extends KinematicBody2D
# Declare member variables here. Examples:
var velocity = Vector2.ZERO
const MAX_SPEED = 100
const ACCELERATION = 5000
const FRICTION = 500
# var a = 2
# var b = "text"
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready	var animationState = animationTree.get("parameters/playback")
signal talk
var inside_pile = 0
var in_conversation = 0

# Called when the node enters the scene tree for the first time.
# func _ready():
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if in_conversation == 0:
		var input_vector = Vector2.ZERO
		input_vector.x = Input.get_action_strength('ui_right') - Input.get_action_strength('ui_left')
		input_vector.y = Input.get_action_strength('ui_down') - Input.get_action_strength('ui_up')
	
		# animations commented
		if input_vector != Vector2.ZERO:
			# animationTree.set("parameters/idle/blend_position", input_vector)
			# animationState.travel('roll')
			velocity = velocity.move_toward(input_vector/input_vector.length()*MAX_SPEED, ACCELERATION*delta)
			animationTree.set("parameters/blend_position", input_vector.x)
		else:
			# animationState.travel('idle')
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION*delta)
			animationTree.set("parameters/blend_position", 0)
		
		velocity = move_and_slide(velocity)
#		pass
		if inside_pile == 1:
			if Input.is_action_pressed("ui_select"):
				inside_pile = 0
				emit_signal("talk")

func _on_Area2D_body_entered(body):
	inside_pile = 1

func _on_Area2D_body_exited(body):
	inside_pile = 0

func _on_Textbox_conversation_start():
	in_conversation = 1

func _on_Textbox_conversation_end():
	in_conversation = 0
