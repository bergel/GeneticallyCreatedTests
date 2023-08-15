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
	^ GCPoint new x: x + anotherPoint x y: y + anotherPoint y; yourself
]

{ #category : #initialization }
GCPoint >> initialize [
	super initialize.
	x := 0.
	y := 0
]

{ #category : #arithmetic }
GCPoint >> negated [
	^ GCPoint new x: x negated y: y negated
]

{ #category : #'instance creation' }
GCPoint >> printOn: str [
	str 
		nextPutAll: 'GCPoint(';
		nextPutAll: x asString; 
		nextPutAll: ',';
		nextPutAll: y asString;
		nextPutAll: ')'
]

{ #category : #accessing }
GCPoint >> x [
	^ x
]

{ #category : #'instance creation' }
GCPoint >> x: xValue y: yValue [
	x := xValue.
	y := yValue.
]

{ #category : #accessing }
GCPoint >> y [
	^ y
]
