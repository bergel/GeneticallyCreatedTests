Class {
	#name : #S2WeakLargeIdentityDictionary,
	#superclass : #Collection,
	#instVars : [
		'tally',
		'items'
	],
	#category : #'Spy2-Core-Utils'
}

{ #category : #'as yet unclassified' }
S2WeakLargeIdentityDictionary >> at: key [
	^ self at: key ifAbsent: [ self errorKeyNotFound: key ]
]

{ #category : #'as yet unclassified' }
S2WeakLargeIdentityDictionary >> at: key ifAbsent: aBlock [
	|item hash|
	hash := key largeIdentityHash \\ self capacity + 1.
	self cleanFirstTableItemsAt: hash.
	item := items at: hash.
	[ item isNotNullItem ] whileTrue: [ 
		self cleanTableItemsFrom: item.
		item key == key ifTrue: [ ^ item value ].
		item := item next.
		 ].
	^ aBlock value
]

{ #category : #'as yet unclassified' }
S2WeakLargeIdentityDictionary >> at: key ifAbsentPut: aBlock [ 
	^ self at: key ifAbsent: [self at: key put: aBlock value]
]

{ #category : #'as yet unclassified' }
S2WeakLargeIdentityDictionary >> at: key ifPresent: presentBlock ifAbsent: absentBlock [
	|item hash|
	hash := key largeIdentityHash \\ self capacity + 1.
	self cleanFirstTableItemsAt: hash.
	item := items at: hash.
	[ item isNotNullItem ] whileTrue: [ 
		item key == key ifTrue: [ ^ presentBlock value: item value ].
		item := item next.
		self cleanTableItemsFrom: item.
		 ].
	^ absentBlock value
]

{ #category : #'as yet unclassified' }
S2WeakLargeIdentityDictionary >> at: key put: value [
	|item prevItem hash|
	hash := key largeIdentityHash \\ self capacity + 1.
	self cleanFirstTableItemsAt: hash.
	item := (items at: hash).
	"No elements in the list"
	item isNullItem ifTrue: [ 
		tally := tally + 1.
		items 
			at: hash 
			put: (S2WeakLargeTableItem new
				key: key;
				value: value;
				next: item;
				yourself).
		^ value ].
	"Usual case"
	[ item isNotNullItem ] whileTrue: [ 
		self cleanTableItemsFrom: item.
		item key == key ifTrue: [ 
			item value: value.
			^ value ].
		prevItem := item.
		item := item next ].
	"If we reach here it means that the key is not in the dictionary"
	tally := tally + 1.
	prevItem next:
		(S2WeakLargeTableItem new
			key: key;
			value: value;
			next: item;
			yourself).
	^ value
]

{ #category : #'as yet unclassified' }
S2WeakLargeIdentityDictionary >> capacity [
	^ 131072
]

{ #category : #'as yet unclassified' }
S2WeakLargeIdentityDictionary >> cleanFirstTableItemsAt: index [
	|item|
	item := items at: index.
	[ item isNotNullItem and: [ item key == nil ] ] whileTrue: [ 
		tally := tally - 1.
		item := item next ].
	items at: index put: item
]

{ #category : #'as yet unclassified' }
S2WeakLargeIdentityDictionary >> cleanTableItemsFrom: startingItem [
	|item|
	item := startingItem next.
	[ item isNotNullItem and: [ item key == nil ] ] whileTrue: [ 
		tally := tally - 1.
		item := item next ].
	startingItem next: item
]

{ #category : #'as yet unclassified' }
S2WeakLargeIdentityDictionary >> do: aBlock [
	^self valuesDo: aBlock
]

{ #category : #'as yet unclassified' }
S2WeakLargeIdentityDictionary >> errorKeyNotFound: aKey [
	KeyNotFound signalFor: aKey
]

{ #category : #'as yet unclassified' }
S2WeakLargeIdentityDictionary >> includesKey: key [
	|item hash|
	hash := key largeIdentityHash \\ self capacity + 1.
	self cleanFirstTableItemsAt: hash.
	item := items at: hash.
	[ item isNotNullItem ] whileTrue: [ 
		item key == key ifTrue: [ ^ true ].
		item := item next.
		 ].
	^ false
]

{ #category : #'as yet unclassified' }
S2WeakLargeIdentityDictionary >> initialize [

	tally := 0.
	items := (1 to: self capacity) collect: [ :i | S2NullLargeTableItem uniqueInstance ]
]

{ #category : #'as yet unclassified' }
S2WeakLargeIdentityDictionary >> keys [
	^Array new: tally streamContents: [ :stream |
		self keysDo: [ :key | stream nextPut: key ] ]
]

{ #category : #'as yet unclassified' }
S2WeakLargeIdentityDictionary >> keysAndValuesDo: aBlock [
	tally = 0 ifTrue: [ ^self ].
	1 to: 4096 do: [ :index |
		|item|
		self cleanFirstTableItemsAt: index.
		item := (items at: index).
		[ item isNotNullItem ] whileTrue: [ 
			aBlock 
				value: item key 
				value: item value.
			item := item next.
		 ]. ]
]

{ #category : #'as yet unclassified' }
S2WeakLargeIdentityDictionary >> keysDo: aBlock [
	tally = 0 ifTrue: [ ^self ].
	1 to: 4096 do: [ :index |
		|item|
		self cleanFirstTableItemsAt: index.
		item := (items at: index).
		[ item isNotNullItem ] whileTrue: [ 
			aBlock 
				value: item key.
			item := item next.
		 ]. ]
]

{ #category : #'as yet unclassified' }
S2WeakLargeIdentityDictionary >> postCopy [
	items := items collect: #copy
]

{ #category : #'as yet unclassified' }
S2WeakLargeIdentityDictionary >> removeKey: key ifAbsent: aBlock [
	|item hash|
	hash := key largeIdentityHash + 1.
	self cleanFirstTableItemsAt: hash.
	item := (items at: hash + 1).
	"Need to remove first element"
	(item isNotNullItem and: [ item key == key ]) ifTrue: [ 
		tally := tally - 1.
		items at: hash put: item next.
		^ key
		 ].
	"Usual case"
	item := item next.
	[ item isNotNullItem ] whileTrue: [ 
		item key == key ifTrue: [ 
			^ key ].
		item := item next.
		 ].
	"The key is not in the dictionary"
	^ aBlock value
]

{ #category : #'as yet unclassified' }
S2WeakLargeIdentityDictionary >> size [
	^ tally
]

{ #category : #'as yet unclassified' }
S2WeakLargeIdentityDictionary >> values [
	^Array new: tally streamContents: [ :stream |
		self valuesDo: [ :key | stream nextPut: key ] ]
]

{ #category : #'as yet unclassified' }
S2WeakLargeIdentityDictionary >> valuesDo: aBlock [
	tally = 0 ifTrue: [ ^self ].
	1 to: 4096 do: [ :index |
		|item|
		self cleanFirstTableItemsAt: index.
		item := (items at: index).
		[ item isNotNullItem ] whileTrue: [ 
			aBlock 
				value: item value.
			item := item next.
		 ]. ]
]
