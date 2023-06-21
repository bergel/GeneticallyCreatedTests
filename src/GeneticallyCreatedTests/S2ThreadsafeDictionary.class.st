Class {
	#name : #S2ThreadsafeDictionary,
	#superclass : #Object,
	#instVars : [
		'dict',
		'mutex'
	],
	#category : #'GeneticallyCreatedTests-ProfilingFramework-Spy'
}

{ #category : #'instance creation' }
S2ThreadsafeDictionary class >> forDictionary: aDictionary [
	^ self new
		dict: aDictionary;
		yourself
]

{ #category : #'instance creation' }
S2ThreadsafeDictionary class >> on: aDictionary [
	^ self forDictionary: aDictionary
]

{ #category : #adding }
S2ThreadsafeDictionary >> associationAt: key [
	^ mutex critical: [ dict associationAt: key ]
]

{ #category : #'as yet unclassified' }
S2ThreadsafeDictionary >> associationAt: key ifAbsent: aBlock [
	^ mutex critical: [ dict associationAt: key ifAbsent: aBlock ]
]

{ #category : #'as yet unclassified' }
S2ThreadsafeDictionary >> associationAt: key ifPresent: aBlock [
	^ mutex critical: [ dict associationAt: key ifPresent: aBlock ]
]

{ #category : #accessing }
S2ThreadsafeDictionary >> at: key [
	^ mutex critical: [ dict at: key ]
]

{ #category : #accessing }
S2ThreadsafeDictionary >> at: key ifAbsent: aBlock [
	^ mutex critical: [ dict at: key ifAbsent: aBlock ]
]

{ #category : #accessing }
S2ThreadsafeDictionary >> at: key ifAbsentPut: aBlock [
	^ mutex critical: [ dict at: key ifAbsentPut: aBlock ]
]

{ #category : #accessing }
S2ThreadsafeDictionary >> at: key ifPresent: aBlock [
	^ mutex critical: [ dict at: key ifPresent: aBlock ]
]

{ #category : #accessing }
S2ThreadsafeDictionary >> at: key ifPresent: aPresentBlock ifAbsent: anAbsentBlock [
	^ mutex critical: [ dict at: key ifPresent: aPresentBlock ifAbsent: anAbsentBlock ]
]

{ #category : #accessing }
S2ThreadsafeDictionary >> at: key ifPresent: aPresentBlock ifAbsentPut: anAbsentBlock [
	^ mutex critical: [ dict at: key ifPresent: aPresentBlock ifAbsentPut: anAbsentBlock ]
]

{ #category : #accessing }
S2ThreadsafeDictionary >> at: key put: anObject [
	^ mutex critical: [ dict at: key put: anObject ]
]

{ #category : #accessing }
S2ThreadsafeDictionary >> dict [
	^ dict
]

{ #category : #accessing }
S2ThreadsafeDictionary >> dict: aDictionary [
	dict := aDictionary
]

{ #category : #testing }
S2ThreadsafeDictionary >> includesAssociation: anAssociation [
	^ mutex critical: [ dict includesAssociation: anAssociation ]
]

{ #category : #testing }
S2ThreadsafeDictionary >> includesKey: key [
	^ mutex critical: [ dict includesKey: key ]
]

{ #category : #initialization }
S2ThreadsafeDictionary >> initialize [
	super initialize.
	mutex := Mutex new
]

{ #category : #testing }
S2ThreadsafeDictionary >> isDictionary [
	^ true
]

{ #category : #copying }
S2ThreadsafeDictionary >> postCopy [
	dict := dict copy.
	mutex := Mutex new
]

{ #category : #accessing }
S2ThreadsafeDictionary >> removeKey: key [ 
	^ mutex critical: [ dict removeKey: key ]
]

{ #category : #removing }
S2ThreadsafeDictionary >> removeKey: key ifAbsent: aBlock [ 
	^ mutex critical: [ dict removeKey: key ifAbsent: aBlock ]
]
