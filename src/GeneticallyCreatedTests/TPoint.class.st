Class {
	#name : #TPoint,
	#superclass : #Object,
	#instVars : [
		'x',
		'y'
	],
	#category : #'GeneticallyCreatedTests-Tests'
}

{ #category : #accessing }
TPoint >> add: anotherPoint [
	^ TPoint new x: x + anotherPoint x; y: y + anotherPoint y; yourself
]

{ #category : #initialization }
TPoint >> initialize [
	super initialize.
	x := 0.
	y := 0
]

{ #category : #arithmetic }
TPoint >> negated [
	^ TPoint new x: x negated; y: y negated
]

{ #category : #accessing }
TPoint >> x [
	^ x
]

{ #category : #accessing }
TPoint >> x: anX [ 
	x := anX
]

{ #category : #accessing }
TPoint >> y [
	^ y
]

{ #category : #accessing }
TPoint >> y: anY [
	y := anY
]
