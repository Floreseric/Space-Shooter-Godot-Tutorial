extends Area2D

var speed : int
var rotSpeed : float
var direction := Vector2(0,1)
signal collision


@export var score = 3 
func _ready() -> void:
	
	
	var rng := RandomNumberGenerator.new()
	
	#start position
	var width = get_viewport().get_visible_rect().size[0]
	var random_x = rng.randi_range(0,width)
	var random_y = rng.randi_range(-150,-50)
	position = Vector2(random_x,random_y)
	
	#start texture
	var meteorImage = [load("res://Space shooter redux/PNG/Meteors/meteorBrown_big1.png"), 
	load("res://Space shooter redux/PNG/Meteors/meteorBrown_big2.png"),
	load("res://Space shooter redux/PNG/Meteors/meteorBrown_big3.png"),
	load("res://Space shooter redux/PNG/Meteors/meteorBrown_big4.png"),
	]
	#create and set texture
	var random_texture = rng.randi_range(0,meteorImage.size()-1)
	$MeteorSprite.set_texture(meteorImage[random_texture])
	
	#randomize speed
	speed = rng.randi_range(300,700)
	
	#randomize rotSpeed
	rotSpeed = rng.randf_range(-10.0,10.0)
	
	#randomize direction
	if position[0] > width-width*0.30:
		direction[0] = rng.randf_range(-0.8,0.2)
	elif position[0] <= width*0.30:
		direction[0] = rng.randf_range(-0.2,0.8)
	else:
		direction[0] = rng.randf_range(-0.8,0.8)
	
	
func _process(delta: float) -> void:
	position += direction * speed * delta
	rotation += rotSpeed * delta

	
func _on_body_entered(_body: Node2D) -> void:
	collision.emit()
	


func _on_sprite_1_texture_changed() -> void:
	pass # Replace with function body.


func _on_area_entered(area: Area2D) -> void:
	get_tree().call_group("ui", 'add_score', score)
	area.queue_free()
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
