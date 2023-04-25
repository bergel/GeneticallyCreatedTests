Class {
	#name : #GCT,
	#superclass : #Object,
	#instVars : [
		'random',
		'targetClass'
	],
	#category : #'GeneticallyCreatedTests-Core'
}

{ #category : #'as yet unclassified' }
GCT >> buildObjectCreationStatement [
	^ self buildObjectCreationStatementFor: targetClass
]

{ #category : #'as yet unclassified' }
GCT >> buildObjectCreationStatementFor: aClass [
	^ { aClass . #new }
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
