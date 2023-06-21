Class {
	#name : #S2SlotPlugin,
	#superclass : #S2ClassPlugin,
	#instVars : [
		'newSlots',
		'instrumentedClasses',
		'prototype'
	],
	#category : #'Spy2-Core-Plugins-Class'
}

{ #category : #'instance creation' }
S2SlotPlugin class >> forReadingAndWritingOn: aProfiler [

	^ (self on: aProfiler)
			prototype: S2Slot slotForReadingAndWriting;
			yourself
]

{ #category : #'instance creation' }
S2SlotPlugin class >> forReadingOn: aProfiler [

	^ (self on: aProfiler)
			prototype: S2Slot slotForReading;
			yourself
]

{ #category : #'instance creation' }
S2SlotPlugin class >> forWritingOn: aProfiler [

	^ (self on: aProfiler)
			prototype: S2Slot slotForWriting;
			yourself
]

{ #category : #'instance creation' }
S2SlotPlugin class >> new [
	S2Profiler hasSlots ifFalse: [ Error signal: 'You need Pharo4 image to use slots.' ].
	^ super new 
]

{ #category : #hooks }
S2SlotPlugin >> initialize [
	super initialize.
	newSlots := Dictionary new.
	prototype := S2Slot slotForReadingAndWriting
]

{ #category : #hooks }
S2SlotPlugin >> installOn: class [
	| slotsForCls |
	class isTrait
		ifTrue: [ ^ self ].
	slotsForCls := OrderedCollection new.
	newSlots at: class put: slotsForCls.
	{class.
	class class}
		do: [ :cls | 
			cls slots
				do: [ :slot | 
					| newSlot |
					self
						assert: [ slot isSpy not ]
						description: 'Trying to instrument an already instrumented slot.'.
					newSlot := self prototype
						profiler: self profiler;
						originalSlot: slot;
						name: slot name;
						index: slot index;
						slotClass: cls.
					slotsForCls add: newSlot.
					cls classLayout replaceSlot: slot with: newSlot ] ].
	(({class.
	class class} flatCollect: #withAllSubclasses) asSet
		flatCollect: #methods)
		do: [ :m | 
			m hasInstVarRef
				ifTrue: [ m recompile ] ].
	^ class
]

{ #category : #hooks }
S2SlotPlugin >> priority [
	^ 0
]

{ #category : #accessing }
S2SlotPlugin >> prototype [
	^ prototype copy
]

{ #category : #accessing }
S2SlotPlugin >> prototype: anObject [
	prototype := anObject
]

{ #category : #hooks }
S2SlotPlugin >> uninstallFrom: cls [
	cls isTrait ifTrue: [ ^ self ].
	(newSlots at: cls ifAbsent: [^ self ]) do: #uninstall.
	newSlots removeKey: cls.
	((cls classWithMetaclass flatCollect: #withAllSubclasses) asSet flatCollect: #methods) 
		do: [ :m | m hasInstVarRef ifTrue: [ m recompile ] ].
]
