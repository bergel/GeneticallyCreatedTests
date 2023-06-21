Class {
	#name : #S2WeakLargeTableItem,
	#superclass : #Object,
	#instVars : [
		'key',
		'value',
		'next'
	],
	#category : #'Spy2-Core-Utils'
}

{ #category : #'as yet unclassified' }
S2WeakLargeTableItem >> collect: aBlock [
| newCollection index|
	newCollection := self species new: self size.
	index := 1.
	self do: [ :ti |
		newCollection at: index put: (aBlock value: ti).
		index := index + 1].
	^ newCollection
]

{ #category : #'as yet unclassified' }
S2WeakLargeTableItem >> do: aBlock [
	|node|
	node := self.
	[ node isNotNullItem ] whileTrue: [ 
		aBlock value: node.
		node := node next ]
]

{ #category : #'as yet unclassified' }
S2WeakLargeTableItem >> initialize [
	super initialize.
	next := S2NullLargeTableItem uniqueInstance.
	key := WeakArray new: 1
]

{ #category : #testing }
S2WeakLargeTableItem >> isNotNullItem [
	^ true
]

{ #category : #testing }
S2WeakLargeTableItem >> isNullItem [
	^ false
]

{ #category : #accessing }
S2WeakLargeTableItem >> key [
	^ key first
]

{ #category : #accessing }
S2WeakLargeTableItem >> key: anObject [
	key at: 1 put: anObject
]

{ #category : #accessing }
S2WeakLargeTableItem >> next [
	^ next
]

{ #category : #accessing }
S2WeakLargeTableItem >> next: anObject [
	next := anObject
]

{ #category : #'as yet unclassified' }
S2WeakLargeTableItem >> postCopy [
	next := next copy
]

{ #category : #'as yet unclassified' }
S2WeakLargeTableItem >> printOn: stream [
	stream nextPutAll: 'WeakList #( '.
	self do: [ :i |
		stream 
			nextPut: $';
			nextPutAll: (i key -> i value) printString;
			nextPut: $';
			space ].
	stream nextPutAll: ')'
]

{ #category : #'as yet unclassified' }
S2WeakLargeTableItem >> size [
	|size|
	size := 0.
	self do: [ :i | size := size + 1 ].
	^ size
]

{ #category : #'as yet unclassified' }
S2WeakLargeTableItem >> species [
	^ Array
]

{ #category : #accessing }
S2WeakLargeTableItem >> value [
	^ value
]

{ #category : #accessing }
S2WeakLargeTableItem >> value: anObject [
	value := anObject
]
