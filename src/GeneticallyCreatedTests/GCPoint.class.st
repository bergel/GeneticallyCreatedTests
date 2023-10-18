Class {
	#name : #GCPoint,
	#superclass : #Object,
	#instVars : [
		'x',
		'y'
	],
	#category : #'GeneticallyCreatedTests-Tests'
}

{ #category : #initialization }
GCPoint >> add: aPoint [
	^ GCPoint new x: aPoint x + x y: aPoint y + y; yourself
]

{ #category : #initialization }
GCPoint >> initialize [ 
	super initialize.
	x := 0.
	y := 0.
	
]

{ #category : #initialization }
GCPoint >> negated [ 
	^ GCPoint new x: x negated y: y negated
]

{ #category : #initialization }
GCPoint >> printOn: str [
	str nextPutAll: 'Point('.
	str nextPutAll: x asString.
	str nextPutAll: ','.
	str nextPutAll: y asString.
	str nextPutAll: ')'.
]

{ #category : #initialization }
GCPoint >> x [ 
	^ x
]

{ #category : #initialization }
GCPoint >> x: anX y: aY [
	x := anX.
	y := aY
]

{ #category : #initialization }
GCPoint >> y [
	^ y
]
