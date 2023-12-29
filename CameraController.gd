extends Camera3D

#Zoom
@export var min_zoom: int = 1
@export var max_zoom: int = 3
@export var zoom_speed: float = 10
@export var zoom_speed_damp: float = 0.9
var zoom_direction : float = 0
var zooming : bool = false
const GROUND_PLANE = Plane(Vector3.FORWARD, 0)
const RAY_LENGTH = 1000

#Mouvement
@export var min_move: Vector3 = Vector3(-5, 0, -5)
@export var max_move: Vector3 = Vector3(5, 0, 5)
@export var move_speed: int = 5
@export var move_speed_damp: Vector3 = Vector3(.5, 0, .5)
var move_delta: Vector3 = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move(delta)
	zoom(delta)

func _input(event):

	if Input.is_action_pressed("MoveRight"):
		move_delta = Vector3.RIGHT
	if Input.is_action_pressed("MoveLeft"):
		move_delta = Vector3.LEFT
	if Input.is_action_pressed("MoveUp"):
		move_delta = Vector3.FORWARD
	if Input.is_action_pressed("MoveDown"):
		move_delta = Vector3.BACK
	if Input.is_action_pressed("ui_accept"):
		print("souris=" + str(get_ground_click_location()))
	if Input.is_action_pressed("ZoomIn"):
		zoom_direction = -1
		zooming = true
	if Input.is_action_pressed("ZoomOut"):
		zoom_direction = 1
		zooming = true

	
func zoom(delta: float):
	#On s'assure que la camera reste dans les limites
	var new_zoom = clamp(
		position.y + zoom_speed * zoom_direction * delta,
		min_zoom,
		max_zoom
		)
	#Sauve la position de la souris sur la carte
	var pointing_at = get_ground_click_location()
	#print(str(pointing_at))
	#On applique la transformation
	position.y = new_zoom
	#reinitialiser le zoom et ralentissement progressif
	zoom_direction *= zoom_speed_damp
	if abs(zoom_direction) <= 0.0001:
		zoom_direction = 0
		zooming = false
	#Bouger la camera pour garder la meme position de curseur sur la carte
	if pointing_at != Vector3.ZERO and zooming:
		realign_camera(pointing_at)
		
	
func get_ground_click_location() -> Vector3:
	var mouse_pos = get_viewport().get_mouse_position()
	#print('mouse_pos=' + str(mouse_pos))
	var ray_from = project_ray_origin(mouse_pos)
	#print('Ray_from=' + str(ray_from))
	var ray_to = ray_from + project_ray_normal(mouse_pos) * RAY_LENGTH
	#print('ray_to=' + str(ray_to))
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.create(ray_from,ray_to)
	ray_query.collide_with_areas = true
	var pos = space.intersect_ray(ray_query).get("position")
	if pos:
		return pos / 100
	return Vector3.ZERO

func realign_camera(location: Vector3):
	#print('location=' + str(location))
	var new_location = get_ground_click_location()
	#print('new_location=' + str(new_location))
	var displacement = location - new_location
	position += displacement
	
func move(delta: float):
	#Deplacer la cam
	var new_pos = position + move_delta * delta * move_speed
	position.x = clamp(
		new_pos.x,
		min_move.x,
		max_move.x
	)
	position.z = clamp(
		new_pos.z,
		min_move.z,
		max_move.z
	)
	#Ralentissement progressif
	move_delta *= move_speed_damp
	if abs(move_delta.x) <= 0.0001:
		move_delta.x = 0
	if abs(move_delta.z) <= 0.0001:
		move_delta.z = 0
	#print(str(position))
