Class {
	#name : #MyPoint,
	#superclass : #Object,
	#instVars : [
		'x',
		'y'
	],
	#category : #'GeneticallyCreatedTests-Core'
}

{ #category : #initialization }
MyPoint >> initialize [
	super initialize.
	x := 0.
	y := 0
]
