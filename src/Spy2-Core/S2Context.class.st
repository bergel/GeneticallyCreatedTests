Class {
	#name : #S2Context,
	#superclass : #S2ProcessVariable,
	#category : #'Spy2-Core-Utils'
}

{ #category : #accessing }
S2Context class >> pop [
	| frame |
	frame := self value.
	self value: frame sender.
	^ frame
]

{ #category : #adding }
S2Context class >> push: anSpyFrame [

	anSpyFrame sender: self value.
	self value: anSpyFrame.
	^ anSpyFrame
]

{ #category : #accessing }
S2Context class >> top [

	^ self value
]
