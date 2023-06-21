Extension { #name : #CompiledMethod }

{ #category : #'*Spy2-Core' }
CompiledMethod >> addOutgoingCalls: aSpyMethod [
	"Do nothing"
]

{ #category : #'*Spy2-Core-Testing' }
CompiledMethod >> allIncomingCalls [
	^ #()
]

{ #category : #'*Spy2-Core' }
CompiledMethod >> asSpyRingDefinition [
	^ self asActiveRingDefinition
]

{ #category : #'*Spy2-Core-Copying' }
CompiledMethod >> copyFor: aBehavior [
	| copy numberOfLiterals superRef |
	numberOfLiterals := self numLiterals.
	copy := self copy.
	superRef := (self literalAt: numberOfLiterals) copy.
	superRef value: aBehavior.
	copy literalAt: numberOfLiterals put: superRef.
	^ copy
]

{ #category : #'*Spy2-Core' }
CompiledMethod >> createSpy: spy [

	^ spy profiler createSpyMethod: self
]

{ #category : #'*Spy2-Core' }
CompiledMethod >> getSpy: spy [

	^ spy profiler getSpyMethod: self
]

{ #category : #'*Spy2-Core-Testing' }
CompiledMethod >> hasSpySlot [
	^ self literals anySatisfy: [ :slot | slot isKindOf: S2Slot ]
]

{ #category : #'*Spy2-Core-Testing' }
CompiledMethod >> incomingCalls [
	^ #()
]

{ #category : #'*Spy2-Core-Testing' }
CompiledMethod >> isSpy [
	^ (self objectAt: 2) isSpyMethod
]

{ #category : #'*Spy2-Core-Copying' }
CompiledMethod >> methodSpy [
	self assert: [ self isSpy ].
	^ self objectAt: 2
]

{ #category : #'*Spy2-Core-Copying' }
CompiledMethod >> originalMethod [
	^ self methodSpy originalMethod
]

{ #category : #'*Spy2-Core-AccessingPragmas' }
CompiledMethod >> pragmaAt: aKey [
	"Answer the pragma with selector aKey, or nil if none."
	| propertiesOrSelector |
	self isSpy ifFalse: 
		[ ^(propertiesOrSelector := self penultimateLiteral) isMethodProperties
			ifTrue: [propertiesOrSelector at: aKey ifAbsent: [nil]]
			ifFalse: [nil] ].
	self methodClass == S2Profiler class ifTrue: [ ^ #() ].
	^ self originalMethod pragmaAt: aKey
		
]

{ #category : #'*Spy2-Core-AccessingPragmas' }
CompiledMethod >> pragmas [
	| selectorOrProperties |
	^(selectorOrProperties := self penultimateLiteral) isMethodProperties
		ifTrue: [selectorOrProperties pragmas]
		ifFalse: [#()]
]

{ #category : #'*Spy2-Core-Copying' }
CompiledMethod >> replaceLiteral: anObject by: anotherObject [
	1 to: self numLiterals do: [ :i | 
		((self literalAt: i) = anObject)
			ifTrue: [ self literalAt: i put: anotherObject ]
	]
]

{ #category : #'*Spy2-Core-Copying' }
CompiledMethod >> replaceLiterals: associations [
	associations do: [:assoc | self replaceLiteral: assoc key by: assoc value ]
]

{ #category : #'*Spy2-Core' }
CompiledMethod >> responsibleSpy [
	^ self propertyValueAt: #responsible
]

{ #category : #'*Spy2-Core' }
CompiledMethod >> responsibleSpy: spy [

	^ self propertyAt: #responsible put: spy
]

{ #category : #'*Spy2-Core' }
CompiledMethod >> withAllIncomingCalls [
	^ Array with: self 
]

{ #category : #'*Spy2-Core-Testing' }
CompiledMethod >> writesInstanceVariable [
	^ self ast allChildren anySatisfy: [ :node |
		node isVariable and: [ 
			node parent isAssignment and: [ 
				node parent variable = node and: [ 
					node isInstance ] ] ] ]
]
