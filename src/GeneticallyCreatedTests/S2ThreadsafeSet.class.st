Class {
	#name : #S2ThreadsafeSet,
	#superclass : #Object,
	#instVars : [
		'set',
		'mutex'
	],
	#category : #'GeneticallyCreatedTests-ProfilingFramework-Spy'
}

{ #category : #'instance creation' }
S2ThreadsafeSet class >> on: aSet [
	^ self new
		set: aSet;
		yourself
]

{ #category : #adding }
S2ThreadsafeSet >> add: anObject [
	mutex critical: [ set add: anObject ]
]

{ #category : #testing }
S2ThreadsafeSet >> includes: anObject [
	^ mutex critical: [ set includes: anObject ]
]

{ #category : #testing }
S2ThreadsafeSet >> includes: anObject ifAbsent: aBlock [
	^ mutex critical: [ 
		(set includes: anObject)
			ifFalse: aBlock ]
]

{ #category : #initialization }
S2ThreadsafeSet >> initialize [
	super initialize.
	mutex := Mutex new
]

{ #category : #accessing }
S2ThreadsafeSet >> set [
	^ set
]

{ #category : #accessing }
S2ThreadsafeSet >> set: anObject [
	set := anObject
]
