extends Camera3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

func _input(event):
	if Input.is_action_pressed("MoveRight"):
		translate_object_local(Vector3.RIGHT * get_process_delta_time() * 500)
	if Input.is_action_pressed("MoveLeft"):
		translate_object_local(Vector3.LEFT * get_process_delta_time() * 500)
	if Input.is_action_pressed("MoveUp"):
		translate_object_local(Vector3.UP * get_process_delta_time() * 500)
	if Input.is_action_pressed("MoveDown"):
		translate_object_local(Vector3.DOWN * get_process_delta_time() * 500)
	if Input.is_action_pressed("ZoomIn"):
		translate_object_local(Vector3.FORWARD * get_process_delta_time() * 1000)
	if Input.is_action_pressed("ZoomOut"):
		translate_object_local(Vector3.BACK * get_process_delta_time() * 1000)
