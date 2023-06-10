Class {
	#name : #GCTStatement,
	#superclass : #Object,
	#instVars : [
		'gct',
		'newVariable',
		'type',
		'example',
		'index'
	],
	#category : #'GeneticallyCreatedTests-Core-CodeGeneration'
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
GCTStatement >> gct: aGCT [

	gct := aGCT
]

{ #category : #accessing }
GCTStatement >> index [

	^ index
]

{ #category : #accessing }
GCTStatement >> index: anObject [

	index := anObject
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

	^ example
]

{ #category : #accessing }
GCTStatement >> objectExample: anObject [

	example := anObject
]

{ #category : #'as yet unclassified' }
GCTStatement >> relevantSelectors [
	"Return the relevant selectors to be invoked"
	^ type selectors copyWithoutAll: #( #initialize )
]

{ #category : #initialization }
GCTStatement >> resetObjectExample [
	example := nil
]

{ #category : #accessing }
GCTStatement >> type [

	^ type
]

{ #category : #accessing }
GCTStatement >> type: aClass [
	self assert: [ aClass ~~ nil class ].
	type := aClass
]
