extends Camera2D

enum Camera2DProcessMode {
		CAMERA2D_PROCESS_PHYSICS = 0
	}

func _ready():
	make_current()
	zoom = Vector2(0.75,0.75)
	set_zoom(zoom)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	align()
