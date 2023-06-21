Class {
	#name : #S2Lock,
	#superclass : #S2ProcessVariable,
	#category : #'GeneticallyCreatedTests-ProfilingFramework-Spy'
}

{ #category : #accessing }
S2Lock class >> isLocked [

	^ self value
]

{ #category : #accessing }
S2Lock class >> lock [

	self isLocked ifTrue: [ Error signal: 'The process is already locked' ].
	self value: true
]

{ #category : #accessing }
S2Lock class >> unlock [

	self isLocked ifFalse: [ Error signal: 'The process is not locked' ].
	self value: false
]

{ #category : #accessing }
S2Lock class >> value [

	^ super value ifNil: [ false ]
]
