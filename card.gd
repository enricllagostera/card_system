class_name Card
extends Control

enum Reveal {
	FACE_DOWN,
	FACE_UP,
}

enum Action {
	IDLE,
	SELECTED
}

export(Reveal) var reveal = Reveal.FACE_DOWN
export(Action) var action = Action.IDLE

var id
