extends Area2D

@export var speed = 500

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.scale = Vector2(0,0)
	$AnimatedSprite2D.scale = Vector2(0,0)
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D, 'scale',Vector2(1,1), 0.1).set_ease(Tween.EASE_OUT)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y -= speed * delta


func _on_animated_sprite_2d_animation_finished() -> void:
	$AnimatedSprite2D.play("Pulse")


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
