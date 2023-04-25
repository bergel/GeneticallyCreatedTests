Class {
	#name : #GCTStatement,
	#superclass : #Object,
	#instVars : [
		'newVariable',
		'objectExample',
		'type'
	],
	#category : #'GeneticallyCreatedTests-Core'
}

{ #category : #'as yet unclassified' }
GCTStatement >> buildCodeOn: stream [
	self subclassResponsibility
]

{ #category : #accessing }
GCTStatement >> newVariable [

	^ newVariable
]

{ #category : #accessing }
GCTStatement >> newVariable: anObject [

	newVariable := anObject
]

{ #category : #accessing }
GCTStatement >> objectExample [

	^ objectExample
]

{ #category : #accessing }
GCTStatement >> objectExample: anObject [

	objectExample := anObject
]

{ #category : #accessing }
GCTStatement >> type [

	^ type
]

{ #category : #accessing }
GCTStatement >> type: anObject [

	type := anObject
]
