extends CanvasLayer

static var image = load("res://Space shooter redux/PNG/UI/playerLife1_blue.png")
var time_elapsed := 0
var temp_score := 0
var combo_num := 0
var multiplyer := [1,2,4,8]
var tier := 0

@export var combo_threshold := 5

@onready var score_sound = $ScoreSound
@onready var combo_sound = $ComboSound
@onready var combo_sound2 = $ComboSound2
@onready var multiplyer_graphic = [$MarginContainer3/GOOD,$MarginContainer3/GREAT,$MarginContainer3/EPIC]

func _ready() -> void:
	Global.score = 0
	
func _process(_delta: float) -> void:
	$MarginContainer/Label.text = str(Global.score)
	temp_score = Global.score
	
func set_health(amount):
	#remove all children
	for child in $MarginContainer2/HBoxContainer.get_children():
		child.queue_free()
	#create new children amount is set by health
	for i in amount:
		var text_rect = TextureRect.new()
		text_rect.texture = image
		$MarginContainer2/HBoxContainer.add_child(text_rect)
		text_rect.stretch_mode = TextureRect.STRETCH_KEEP

func add_score(amount):
	combo_num += 1
	Global.score += amount
	score_sound.play()
	
	if combo_num == combo_threshold:
		multiplyer_graphic[tier].set_visible(true)
		if tier >1:
				multiplyer_graphic[tier-1].set_deferred("visible", false)
		#tier cap
		if tier == 2:
			combo_sound2.play()
			Global.score *= multiplyer[tier]
		else:
			combo_sound.play()
			tier += 1
			if tier >1:
				multiplyer_graphic[tier-1].set_visible(false)
			Global.score *= multiplyer[tier]
		combo_num = 0
			
			
			
		

func _reset_combo() -> void:
	combo_num = 0
	tier = 0
	multiplyer_graphic[tier].set_visible(false)
	
func _on_score_timer_timeout() -> void:
	#time_elapsed += 1
	#$MarginContainer/Label.text = str(Global.score + time_elapsed)
	Global.score += 1
