Class {
	#name : #S2ThreadsafeCounter,
	#superclass : #Object,
	#instVars : [
		'count',
		'mutex'
	],
	#category : #'GeneticallyCreatedTests-ProfilingFramework-Spy'
}

{ #category : #accessing }
S2ThreadsafeCounter >> count [
	^ count
]

{ #category : #counting }
S2ThreadsafeCounter >> increment [
	^ self increment: 1
]

{ #category : #counting }
S2ThreadsafeCounter >> increment: anInteger [
	|value|
	mutex critical: [ 
		count := count + anInteger.
		value := count ].
	^ value
]

{ #category : #initializing }
S2ThreadsafeCounter >> initialize [
	super initialize.
	mutex := Mutex new.
	count := 0
]

{ #category : #accessing }
S2ThreadsafeCounter >> setCount: anInteger [
	mutex critical: [ count := anInteger ]
]

{ #category : #accessing }
S2ThreadsafeCounter >> value [
	^ self count
]
