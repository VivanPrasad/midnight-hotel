extends GridContainer

@onready var cards = preload("res://Scenes/Objects/Card.tscn")

var hand : Array[Resource] = [load("res://Data/Cards/Tip1.tres"),load("res://Data/Cards/Tip2.tres"),load("res://Data/Cards/Ghost.tres")]

func _input(_event):
	if Input.is_action_pressed("cards"):
		if not visible:
			visible = true
			update_hand()
			$"../Fade".visible = true
		if $"../New".visible:
			$"../New".visible = false
	else:	
		visible = false
		$"../Fade".visible = false
func _ready():
	pass
func add_card(card):
	hand.append(card)
	$"../New".visible = true

func _process(_delta):
	if Game.hour == 0 and Game.minute == 55:
		remove_card(load("res://Data/Cards/Tip2.tres"))
		remove_card(load("res://Data/Cards/Ghost.tres"))
		remove_card(load("res://Data/Cards/Tip1.tres"))
		if Game.location == 1:
			if not load("res://Data/Cards/Hide.tres") in hand:
				add_card(load("res://Data/Cards/Hide.tres"))
		else:
			if not load("res://Data/Cards/Run.tres") in hand:
				add_card(load("res://Data/Cards/Run.tres"))
	elif Game.hour == 1 and Game.minute == 15:
		if load("res://Data/Cards/Hide.tres") in hand:
			remove_card(load("res://Data/Cards/Hide.tres"))
		elif load("res://Data/Cards/Run.tres") in hand:
			remove_card(load("res://Data/Cards/Run.tres"))
func remove_card(card):
	hand.erase(card)

func clear():
	hand = []
func update_hand():
	columns = hand.size()
	for child in get_children():
		child.queue_free()
	for card in hand:
		var i = cards.instantiate()
		if card.type == "":
			i.get_child(0).get_child(0).text = str(card.desc)
		else:
			i.get_child(0).get_child(0).text = str(card.type) + ": " + str(card.desc)
		add_child(i)
