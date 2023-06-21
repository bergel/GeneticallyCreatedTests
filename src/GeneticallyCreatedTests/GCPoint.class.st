Class {
	#name : #GCPoint,
	#superclass : #Object,
	#instVars : [
		'x',
		'y'
	],
	#category : #'GeneticallyCreatedTests-Tests'
}

{ #category : #accessing }
GCPoint >> add: anotherPoint [
	^ GCPoint new x: x + anotherPoint x; y: y + anotherPoint y; yourself
]

{ #category : #initialization }
GCPoint >> initialize [
	super initialize.
	x := 0.
	y := 0
]

{ #category : #arithmetic }
GCPoint >> negated [
	^ GCPoint new x: x negated; y: y negated
]

{ #category : #accessing }
GCPoint >> x [
	^ x
]

{ #category : #accessing }
GCPoint >> x: anX [ 
	x := anX
]

{ #category : #accessing }
GCPoint >> y [
	^ y
]

{ #category : #accessing }
GCPoint >> y: anY [
	y := anY
]
