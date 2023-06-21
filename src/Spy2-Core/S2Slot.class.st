Class {
	#name : #S2Slot,
	#superclass : #Slot,
	#instVars : [
		'profiler',
		'originalSlot',
		'slotClass',
		'reading',
		'writing'
	],
	#category : #'Spy2-Core-Plugins-Class'
}

{ #category : #'instance creation' }
S2Slot class >> slotForReading [
	^ self new
		reading: true;
		writing: false;
		yourself
]

{ #category : #'instance creation' }
S2Slot class >> slotForReadingAndWriting [
	^ self new
		reading: true;
		writing: true;
		yourself
]

{ #category : #'instance creation' }
S2Slot class >> slotForWriting [
	^ self new
		reading: false;
		writing: true;
		yourself
]

{ #category : #comparing }
S2Slot >> = other [

	^ self == other
]

{ #category : #'code generation' }
S2Slot >> emitStore: methodBuilder [
	
	writing ifFalse: [ ^ originalSlot emitStore: methodBuilder ].
	methodBuilder
		pushDup;
		pushLiteral: self;
		pushReceiver.
	originalSlot emitValue: methodBuilder.
	methodBuilder
		send: #instrumentWrite:receiver:withValue:;
		popTop.
	originalSlot emitStore: methodBuilder
]

{ #category : #'code generation' }
S2Slot >> emitValue: methodBuilder [

	reading ifFalse: [ ^ originalSlot emitValue: methodBuilder ].
	originalSlot emitValue: methodBuilder.
	methodBuilder
		pushDup;
		pushLiteral: self;
		pushReceiver;
		send: #instrumentRead:receiver:;
		popTop.

]

{ #category : #accessing }
S2Slot >> hash [
	^ self identityHash
]

{ #category : #accessing }
S2Slot >> index [
	^ index
]

{ #category : #accessing }
S2Slot >> index: anIndex [
	index := anIndex
]

{ #category : #testing }
S2Slot >> initialize [
	super initialize.
	reading := true.
	writing := true
]

{ #category : #testing }
S2Slot >> isSpecial [ 

	^ true
]

{ #category : #testing }
S2Slot >> isSpy [

	^ true
]

{ #category : #accessing }
S2Slot >> originalSlot [
	^ originalSlot
]

{ #category : #accessing }
S2Slot >> originalSlot: anObject [
	originalSlot := anObject
]

{ #category : #accessing }
S2Slot >> profiler [
	^ profiler
]

{ #category : #accessing }
S2Slot >> profiler: anObject [
	profiler := anObject
]

{ #category : #'meta-object-protocol' }
S2Slot >> read: anObject [
	"We do not instrument primitive read to slots"
	^ originalSlot read: anObject
]

{ #category : #accessing }
S2Slot >> reading [
	^ reading
]

{ #category : #accessing }
S2Slot >> reading: anObject [
	reading := anObject
]

{ #category : #accessing }
S2Slot >> slotClass [
	^ slotClass
]

{ #category : #accessing }
S2Slot >> slotClass: anObject [
	slotClass := anObject
]

{ #category : #util }
S2Slot >> uninstall [
	(self slotClass classLayout slotScope indexOf: self) = 0
		ifFalse: [ self slotClass classLayout replaceSlot: self with: self originalSlot ]
]

{ #category : #'meta-object-protocol' }
S2Slot >> write: aValue to: anObject [
	"We do not instrument primitive write to slots"
	^ originalSlot write: aValue to: anObject
]

{ #category : #accessing }
S2Slot >> writing [
	^ writing
]

{ #category : #accessing }
S2Slot >> writing: anObject [
	writing := anObject
]
