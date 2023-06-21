Class {
	#name : #S2NullLargeTableItem,
	#superclass : #Object,
	#classVars : [
		'Unique'
	],
	#category : #'GeneticallyCreatedTests-ProfilingFramework-Spy'
}

{ #category : #'as yet unclassified' }
S2NullLargeTableItem class >> uniqueInstance [
	^ Unique ifNil: [ Unique := self new ]
]

{ #category : #'as yet unclassified' }
S2NullLargeTableItem >> collect: aBlock [
	^ #()
]

{ #category : #'as yet unclassified' }
S2NullLargeTableItem >> do: aBlock [
]

{ #category : #testing }
S2NullLargeTableItem >> isNotNullItem [
	^ false
]

{ #category : #testing }
S2NullLargeTableItem >> isNullItem [
	^ true
]

{ #category : #'as yet unclassified' }
S2NullLargeTableItem >> size [
	^ 0
]

{ #category : #'as yet unclassified' }
S2NullLargeTableItem >> species [
	^ Array
]
