Class {
	#name : #MyPoint,
	#superclass : #Object,
	#instVars : [
		'x',
		'y'
	],
	#category : #'GeneticallyCreatedTests-Tests'
}

{ #category : #accessing }
MyPoint >> add: anotherPoint [
	^ MyPoint new x: x + anotherPoint x; y: y + anotherPoint y; yourself
]

{ #category : #initialization }
MyPoint >> initialize [
	super initialize.
	x := 0.
	y := 0
]

{ #category : #arithmetic }
MyPoint >> negated [
	^ MyPoint new x: x negated; y: y negated
]

{ #category : #accessing }
MyPoint >> x [
	^ x
]

{ #category : #accessing }
MyPoint >> x: anX [ 
	x := anX
]

{ #category : #accessing }
MyPoint >> y [
	^ y
]

{ #category : #accessing }
MyPoint >> y: anY [
	y := anY
]
