extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _mouse_enter():
	print_debug(get_parent_node_3d().name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
