extends Control

onready var health_bar = $Health/HealthBar
onready var health_under = $Health/HealthUnder
onready var stamina_under = $LeftBottom/StaminaUnder
onready var stamina_bar = $LeftBottom/StaminaBar
onready var update_tween = $UpdateTween

onready var healthgui = $Health
onready var leftbottom = $LeftBottom
onready var rightbottom = $RightBottom
onready var interactlabel = $InteractLabel
onready var fade = $Transistion/Fade
onready var fadelabel = $Transistion/Label

var health
var stamina
var hud = "nonaction"
var showinteract

export (Color) var healthy_color = Color.green
export (Color) var caution_color = Color.yellow
export (Color) var danger_color = Color.red
export (float, 0 , 1, 0.05) var caution_zone = 0.5
export (float, 0 , 1, 0.05) var danger_zone = 0.2

#func _ready():
#	_on_health_updated()
#	_on_max_health_updated()
#	_on_stamina_updated()
#	_on_max_stamina_updated()
	
func _assign_color(health):
	if health < health_bar.max_value * danger_zone:
		health_bar.tint_progress = danger_color
	elif health < health_bar.max_value * caution_zone:
		health_bar.tint_progress = caution_color
	else:
		health_bar.tint_progress = healthy_color
		
#func _on_health_updated():
#	health = get_parent().get("currenthealth")
#	health_bar.value = get_parent().get("currenthealth")
#	update_tween.interpolate_property(health_under, "value", health_under.value, health, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.2)
#	update_tween.start()
	
#	_assign_color(health)
	
func _on_stamina_updated():
	stamina = get_parent().get("currentstamina")
	stamina_bar.value = get_parent().get("currentstamina")
	update_tween.interpolate_property(stamina_under, "value", stamina_under.value, health, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.2)
	update_tween.start()
	
func _on_max_health_updated():
	health_bar.max_value = get_parent().get("maxhealth")
	
func _on_max_stamina_updated():
	stamina_bar.max_value = get_parent().get("maxstamina")
	
#func _on_Player_healthchanged():
#	_on_health_updated()

func _on_Player_maxhealthchanged():
	_on_max_health_updated()

func _on_Player_staminachanged():
	_on_stamina_updated()

func _on_Player_maxstaminachanged():
	_on_max_stamina_updated()

func _on_Player_changehud(huddata):
	hud = huddata
	match hud:
		"cinematic":
			print("")
		
		"nonaction":
			update_tween.interpolate_property(healthgui,  "rect_position", Vector2(0,0), Vector2(-11,0),0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.2)
			update_tween.interpolate_property(leftbottom,  "rect_position", Vector2(0,0), Vector2(-7,0),0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.2)
			update_tween.interpolate_property(rightbottom,  "rect_position", Vector2(0,0), Vector2(94,0),0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.2)
			update_tween.start()
		
		"showhealth":
			update_tween.interpolate_property(healthgui,  "rect_position", Vector2(-11,0), Vector2(0,0),0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.2)
			update_tween.interpolate_property(leftbottom,  "rect_position", Vector2(-7,0), Vector2(0,0),0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.2)
			update_tween.start()
			yield(get_tree().create_timer(2.0), "timeout")
			update_tween.interpolate_property(healthgui,  "rect_position", Vector2(0,0), Vector2(-11,0),0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.2)
			update_tween.interpolate_property(leftbottom,  "rect_position", Vector2(0,0), Vector2(-7,0),0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.2)
			update_tween.start()
			
		"showammo":
			update_tween.interpolate_property(rightbottom,  "rect_position", Vector2(94,0), Vector2(0,0),0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.2)
			update_tween.start()
			yield(get_tree().create_timer(2.0), "timeout")
			update_tween.interpolate_property(rightbottom,  "rect_position", Vector2(0,0), Vector2(94,0),0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.2)
			update_tween.start()
		
		"action":
			update_tween.interpolate_property(healthgui,  "rect_position", Vector2(-11,0), Vector2(0,0),0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.2)
			update_tween.interpolate_property(leftbottom,  "rect_position", Vector2(-7,0), Vector2(0,0),0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.2)
			update_tween.interpolate_property(rightbottom,  "rect_position", Vector2(94,0), Vector2(0,0),0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.2)
			update_tween.start()

func _on_Player_showinteractui(showdata):
	showinteract = showdata
	match showinteract:
		"show":
			interactlabel.show()
			
		"hide":
			interactlabel.hide()
			
#func fadescreen():
#	update_tween.interpolate_property(fade,  "modulate:a", 0, 255, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 2)
#	update_tween.interpolate_property(fadelabel,  "modulate:a", 0, 255, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 2)
#	update_tween.start()
#	yield(get_tree().create_timer(2.0), "timeout")
#	update_tween.interpolate_property(fade,  "modulate:a", 255, 0, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 2)
#	update_tween.interpolate_property(fadelabel,  "modulate:a", 255, 0, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 2)
#	update_tween.start()

#func _on_Player_transistion(name,location):
#	fadelabel.text = ("-"+name+"-")
#	fadescreen()
