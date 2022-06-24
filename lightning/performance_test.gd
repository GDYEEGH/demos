extends Spatial

var place_position = Vector3(-20,6,-10)

func _ready():
	pass # Replace with function body.

func _process(_delta):
	if Input.is_action_pressed("ui_accept"):
		var l = load("res://lightning.tscn").instance()
		place_position.x += 2
		if place_position.x > 20:
			place_position.z += 2
			place_position.x = -20
		l.transform.origin = place_position
		l.target_position = place_position - Vector3(0,10,0)
		add_child(l)
	$Label.text = "FPS:"+ str(Engine.get_frames_per_second())
	$Label2.text = "child count:"+ str(get_child_count())
