Class {
	#name : #S2ThreadsafeWriteStream,
	#superclass : #Object,
	#instVars : [
		'stream',
		'mutex'
	],
	#category : #'Spy2-Core-Utils'
}

{ #category : #'instance creation' }
S2ThreadsafeWriteStream class >> on: aStream [
	^ self new
		stream: aStream;
		yourself
]

{ #category : #streaming }
S2ThreadsafeWriteStream >> << anObject [
	^ mutex critical: [ stream << anObject ]
]

{ #category : #initialization }
S2ThreadsafeWriteStream >> initialize [
	super initialize.
	mutex := Mutex new
]

{ #category : #streaming }
S2ThreadsafeWriteStream >> nextPut: anObject [
	^ mutex critical: [ stream nextPut: anObject ]
]

{ #category : #streaming }
S2ThreadsafeWriteStream >> nextPutAll: aCollection [
	^ mutex critical: [ stream nextPutAll: aCollection ]
]

{ #category : #accessing }
S2ThreadsafeWriteStream >> stream [
	^ stream
]

{ #category : #accessing }
S2ThreadsafeWriteStream >> stream: anObject [
	stream := anObject
]
