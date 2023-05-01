Class {
	#name : #GCTStatement,
	#superclass : #Object,
	#instVars : [
		'gct',
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
GCTStatement >> gct [

	^ gct
]

{ #category : #accessing }
GCTStatement >> gct: anObject [

	gct := anObject
]

{ #category : #testing }
GCTStatement >> isSimilarTo: aStatement [
	self subclassResponsibility
]

{ #category : #testing }
GCTStatement >> isSimilarToMessage: aStatement [
	self subclassResponsibility
]

{ #category : #testing }
GCTStatement >> isSimilarToObjectCreation: aStatement [
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
