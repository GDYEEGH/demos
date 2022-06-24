extends Spatial

export var number_of_segments = 10
export var segment_spread = 0.4
export var segment_thickness = 0.1
export var target_position = Vector3(0,-6,0)
var segment_positions = []

export var number_of_branches = 4
export var branch_spread = 0.1
export var branch_thickness = 0.05
export var branch_length = 1
var branch_positions = []

export var number_of_small_branches = 4
export var small_branch_spread = 0.1
export var small_branch_thickness = 0.02
export var small_branch_length = 0.5
var small_branch_positions = []
# Called when the node enters the scene tree for the first time.
func _ready():
	var new_multimesh = MultiMesh.new()
	new_multimesh.color_format = MultiMesh.COLOR_8BIT
	new_multimesh.transform_format = MultiMesh.TRANSFORM_3D
	$MultiMeshInstance.multimesh = new_multimesh
	$MultiMeshInstance.multimesh.mesh = CubeMesh.new()
func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		set_segments()
func set_segments():
	$MultiMeshInstance.multimesh.instance_count = number_of_segments + number_of_branches + number_of_small_branches
	randomize()
	var direction = target_position - global_transform.origin
	for s in number_of_segments+1:
		if segment_positions.size() - 1 < number_of_segments:
			segment_positions.append(s * (direction / number_of_segments))
			segment_positions[s] += Vector3(rand_range(-segment_spread,segment_spread),rand_range(-segment_spread,segment_spread),rand_range(-segment_spread,segment_spread))
		else:
			segment_positions[s] = s * (direction / number_of_segments)
			segment_positions[s] += Vector3(rand_range(-segment_spread,segment_spread),rand_range(-segment_spread,segment_spread),rand_range(-segment_spread,segment_spread))
		
	if segment_positions[segment_positions.size() - 1] != direction:
		segment_positions[segment_positions.size() - 1] = direction

	segment_positions[0] = Vector3(0,0,0)
	for m in number_of_segments:
		var transform_mesh = Spatial.new()
			
		transform_mesh.scale = Vector3(segment_thickness,segment_thickness,segment_positions[m].distance_to(segment_positions[m+1])/2+segment_thickness/2)
		transform_mesh.transform.origin = (segment_positions[m] + segment_positions[m+1]) / 2
		transform_mesh.look_at_from_position((segment_positions[m] + segment_positions[m+1]) / 2,segment_positions[m+1],Vector3.LEFT)
			
		$MultiMeshInstance.multimesh.set_instance_transform(m, transform_mesh.transform)
	small_branch_positions = []
	branch_positions = segment_positions.duplicate()
	for b in number_of_branches:
		var spots = branch_positions.duplicate()
		spots.remove(spots.size() - 1)
		var random_segment = randi() % spots.size() 
		branch(branch_positions[random_segment], direction,b)
		branch_positions.remove(random_segment)
	for sb in number_of_small_branches:
		var bspots = small_branch_positions.duplicate()
		if bspots.size() > 1:
			bspots.remove(bspots.size() - 1)
			var random_branch = randi() % bspots.size() 
			small_branch(small_branch_positions[random_branch],direction,sb)
func branch(position,direction, branch_number):
	var destination = position
	destination += direction.normalized() * branch_length
	var dir_total = abs(direction.x) + abs(direction.y) + abs(direction.z)
	dir_total = dir_total / 10
	randomize()
	var rand_x = randi() % 2
	var rand_y = randi() % 2
	var rand_z = randi() % 2
	rand_x = 1 - rand_x * 2
	rand_y = 1 - rand_y * 2
	rand_z = 1 - rand_z * 2
	var old_destination = destination
	destination.x += rand_range((branch_spread + dir_total + branch_length * 0.2) * rand_x,(dir_total + branch_length * 0.2) * rand_x * 0.9)
	destination.y += rand_range((branch_spread + dir_total + branch_length * 0.2) * rand_y,(dir_total + branch_length * 0.2) * rand_y * 0.9)
	destination.z += rand_range((branch_spread + dir_total + branch_length * 0.2) * rand_z,(dir_total + branch_length * 0.2) * rand_z * 0.9)
	destination += direction.normalized() * (branch_length + branch_spread)
	if old_destination.distance_to(target_position - global_transform.origin) > destination.distance_to(target_position - global_transform.origin) * 1.2:
		destination += -direction.normalized() * branch_length * 2

	
	var transform_mesh = Spatial.new()

	if transform.origin.distance_squared_to(destination) <= global_transform.origin.distance_squared_to(target_position - global_transform.origin):
		small_branch_positions.append(destination)
		transform_mesh.scale = Vector3(branch_thickness,branch_thickness,position.distance_to(destination)/2+branch_thickness/2)
		transform_mesh.transform.origin = (position + destination) / 2
		transform_mesh.look_at_from_position((position + destination) / 2,destination,Vector3.LEFT)
	else:
		small_branch_positions.append(destination * 2)
		transform_mesh.scale = Vector3(0,0,0)
	$MultiMeshInstance.multimesh.set_instance_transform(number_of_segments + branch_number, transform_mesh.transform)
	
func small_branch(position,direction,small_branch_number):
	var destination = position
	destination += direction.normalized() * small_branch_length
	
	var dir_total = abs(direction.x) + abs(direction.y) + abs(direction.z)
	dir_total /= 20
	randomize()
	var rand_x = randi() % 2
	var rand_y = randi() % 2
	var rand_z = randi() % 2
	rand_x = 1 - rand_x * 2
	rand_y = 1 - rand_y * 2
	rand_z = 1 - rand_z * 2
	var old_destination = destination
	destination.x += rand_range((small_branch_spread + dir_total + small_branch_length * 0.1) * rand_x,(dir_total + small_branch_length * 0.1) * rand_x * 0)
	destination.y += rand_range((small_branch_spread + dir_total + small_branch_length * 0.1) * rand_y,(dir_total + small_branch_length * 0.1) * rand_y * 0)
	destination.z += rand_range((small_branch_spread + dir_total + small_branch_length * 0.1) * rand_z,(dir_total + small_branch_length * 0.1) * rand_z * 0)
	destination += direction.normalized() * small_branch_length
	if old_destination.distance_to(position) * 2 < destination.distance_to(position):
		destination += -direction.normalized() * small_branch_length * 2
		
	var transform_mesh = Spatial.new()
	
	if transform.origin.distance_squared_to(destination) <= global_transform.origin.distance_squared_to(target_position - global_transform.origin):
		transform_mesh.scale = Vector3(small_branch_thickness,small_branch_thickness,position.distance_to(destination)/2+small_branch_thickness/2)
		transform_mesh.transform.origin = (position + destination) / 2
		transform_mesh.look_at_from_position((position + destination) / 2,destination,Vector3.LEFT)
	else:
		transform_mesh.scale = Vector3(0,0,0)
	$MultiMeshInstance.multimesh.set_instance_transform(number_of_segments + number_of_branches + small_branch_number, transform_mesh.transform)
func _on_Timer_timeout():
	set_segments()
