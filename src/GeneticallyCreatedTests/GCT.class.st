Class {
	#name : #GCT,
	#superclass : #Object,
	#instVars : [
		'random',
		'targetClass',
		'length',
		'chromosome',
		'chromosomeType'
	],
	#category : #'GeneticallyCreatedTests-Core'
}

{ #category : #building }
GCT >> addObjectCreationStatement [

	chromosome add: self buildObjectCreationStatement.
	chromosomeType add: chromosome last second.
]

{ #category : #building }
GCT >> buildChromosome [

	self addObjectCreationStatement.

	length - 1 timesRepeat: [ 
		random next > 0.5
			ifTrue: [ self addMessageStatement ]
			ifFalse: [ self addObjectCreationStatement ] ].
	^ chromosome asArray
]

{ #category : #building }
GCT >> buildMessageStatement [
	^ self buildMessageStatementFor: targetClass
]

{ #category : #building }
GCT >> buildMessageStatementFor: aClass [
	^ {  }
]

{ #category : #building }
GCT >> buildObjectCreationStatement [
	^ self buildObjectCreationStatementFor: targetClass
]

{ #category : #building }
GCT >> buildObjectCreationStatementFor: aClass [
	^ { self newVarName . aClass . #new }
]

{ #category : #building }
GCT >> chromosome [
	^ chromosome
]

{ #category : #initialization }
GCT >> initialize [
	super initialize.
	length := 2.
	chromosome := OrderedCollection new.
	chromosomeType := OrderedCollection new
]

{ #category : #accessing }
GCT >> length [

	^ length
]

{ #category : #accessing }
GCT >> length: anObject [

	length := anObject
]

{ #category : #building }
GCT >> newVarName [
	^ ('v', ((chromosome size + 1) asString)) asSymbol
]

{ #category : #accessing }
GCT >> random [

	^ random
]

{ #category : #accessing }
GCT >> random: aRandom [

	random := aRandom
]

{ #category : #accessing }
GCT >> targetClass [

	^ targetClass
]

{ #category : #accessing }
GCT >> targetClass: aPharoClass [

	targetClass := aPharoClass
]

{ #category : #building }
GCT >> typeOfVariable: aSymbol [
	| index |
	index := chromosome findFirst: [ :tp | tp first == aSymbol ].
	^ chromosomeType at: index
]
