extends Spatial

func _process(_delta):
	if $Spatial.rotation_degrees.x >= 90:
		$Spatial/.rotation_degrees.x = 90
	elif $Spatial.rotation_degrees.x <= -90:
		$Spatial.rotation_degrees.x = -90
	if Input.is_action_pressed("zoom_in"):
		$Spatial/Camera.transform.origin.z -= 1
	elif Input.is_action_pressed("zoom_out"):
		$Spatial/Camera.transform.origin.z += 1
	var direction = Vector3()
	var aim = get_global_transform().basis
	if Input.is_action_pressed("ui_up"):
		direction -= aim.z
	if Input.is_action_pressed("ui_down"):
		direction += aim.z
	if Input.is_action_pressed("ui_left"):
		direction -= aim.x
	if Input.is_action_pressed("ui_right"):
		direction += aim.x

	direction = direction.normalized()
	transform.origin += direction
func _input(event):
	if event is InputEventMouseMotion:
		if Input.is_action_pressed("mouse_down"):
			var dir = -1
			if event.relative.x != 0:
				rotate_object_local(Vector3.UP, dir * event.relative.x * 0.01)
			if event.relative.y != 0:
				$Spatial.rotate_object_local(Vector3.RIGHT, dir * event.relative.y * 0.01)
