Class {
	#name : #S2Method,
	#superclass : #Spy2,
	#instVars : [
		'instrumentedMethod',
		'originalMethod',
		'selector',
		'classSpy',
		'packageSpy',
		'outgoingCalls',
		'incomingCalls',
		'executionTime',
		'staticOutgoingCalls'
	],
	#category : #'Spy2-Core-Metamodel'
}

{ #category : #public }
S2Method class >> notIdentifiedMethod [
	^ self
]

{ #category : #hooks }
S2Method class >> spyClassForMethod [
	^ self
]

{ #category : #accessing }
S2Method >> addIncomingCalls: methodSpy [
	^ self incomingCalls add: methodSpy
]

{ #category : #accessing }
S2Method >> addOutgoingCalls: methodSpy [
	^ self outgoingCalls add: methodSpy
]

{ #category : #hooks }
S2Method >> afterRun: methodName with: listOfArguments in: receiver [

]

{ #category : #'accessing - computed' }
S2Method >> allIncomingCalls [
	| answer |
	answer := OrderedCollection new.
	answer addAll: self incomingCalls.
	self incomingCalls do: [:c |
		answer addAll: c allIncomingCalls ].
	^ answer
]

{ #category : #'accessing - computed' }
S2Method >> allOutgoingCalls [
	| answer |
	answer := OrderedCollection new.
	self allOutgoingCallsRunning: answer.
	^ answer
]

{ #category : #'accessing - computed' }
S2Method >> allOutgoingCallsInSameClass [
	^ self allOutgoingCalls select: [ :spyMethod | spyMethod classSpy == self classSpy ]
]

{ #category : #'accessing - computed' }
S2Method >> allOutgoingCallsRunning: collection [
	self outgoingCalls do: [:c |
		(collection anySatisfy: [:v | v == c ] )
			ifFalse: [ collection add: c. 
						 c allOutgoingCallsRunning: collection] ].

]

{ #category : #hooks }
S2Method >> beforeRun: methodName with: listOfArguments in: receiver [

]

{ #category : #action }
S2Method >> browse [
	Smalltalk tools browser fullOnClass: self compiledMethod methodClass selector: self compiledMethod  selector

]

{ #category : #accessing }
S2Method >> classSpy [
	^ classSpy
]

{ #category : #accessing }
S2Method >> classSpy: anObject [
	classSpy := anObject
]

{ #category : #accessing }
S2Method >> compiledMethod [
	"Return the compiled method that is wrapped by the S2Method"
	^ self originalMethod
]

{ #category : #'accessing - computed' }
S2Method >> currentMethod [

	^ self profiler currentMethod
]

{ #category : #'accessing - computed' }
S2Method >> currentRunningTest [

	^ self profiler currentRunningTest
]

{ #category : #accessing }
S2Method >> executionTime [
	^ executionTime 
	
]

{ #category : #accessing }
S2Method >> executionTime: v [ 
	^ executionTime  := v
	
]

{ #category : #hooks }
S2Method >> flushCache [
	originalMethod flushCache
]

{ #category : #testing }
S2Method >> hasClassSpy [ 
	^ self classSpy notNil
]

{ #category : #testing }
S2Method >> hasIncomingCalls [
	incomingCalls ifNil: [ ^ false ].
	^ self incomingCalls size > 0 
]

{ #category : #testing }
S2Method >> hasNoIncomingCalls [
	^ self hasIncomingCalls not
]

{ #category : #testing }
S2Method >> hasOutgoingCalls [
	outgoingCalls ifNil: [ ^ false ].
	^ self outgoingCalls size > 0 
]

{ #category : #comparison }
S2Method >> hasPreviousVersion [
	
	| lp cls |
	lp := self profiler lastProfile.
	cls := lp classAt: self classSpy className ifNone: [ ^ false ].
	^ cls hasMethodNamed: self selector
]

{ #category : #hooks }
S2Method >> incomingAndOutgoingCallClass [
	^ IdentitySet
]

{ #category : #accessing }
S2Method >> incomingCalls [
	^ incomingCalls ifNil: [ incomingCalls := self incomingAndOutgoingCallClass new ]
]

{ #category : #initialization }
S2Method >> initialize [
	super initialize.
	executionTime := 0.
	outgoingCalls := nil.
	incomingCalls := nil
]

{ #category : #accessing }
S2Method >> instrumentedMethod [
	^ instrumentedMethod
]

{ #category : #accessing }
S2Method >> instrumentedMethod: aTemplateMethod [
	instrumentedMethod := aTemplateMethod
]

{ #category : #testing }
S2Method >> isAbstract [
	"True if the original method is abstract"

	^ self originalMethod isAbstract
]

{ #category : #testing }
S2Method >> isInTestCase [
	^ self classSpy isTestClass
]

{ #category : #testing }
S2Method >> isMethodExisting [
	^ self theClass methodDict includesKey: self selector
]

{ #category : #testing }
S2Method >> isMethodNotExisting [
	^ self isMethodExisting not
]

{ #category : #comparison }
S2Method >> isNewMethod [
	"Return true if the method was not in the previous profile"
	^ self isNotNewMethod not
]

{ #category : #testing }
S2Method >> isNotAMethodExtension [
	"True if I am a class extension"

	^ self originalMethod category first = $*
]

{ #category : #testing }
S2Method >> isNotMethodExtension [
	"True if I am a class extension"

	^ self originalMethod category first ~= $*
]

{ #category : #comparison }
S2Method >> isNotNewMethod [
	"Return true if the same method was in the last profile"
	| lp cls |
	self assert: [ self profiler isReadyForComparison ] description: 'Cannot be compared, need to send #setForComparison to a profile'.
	
	lp := self profiler lastProfile.
	cls := lp classAt: self classSpy className ifNone: [ ^ false ].
	^ cls hasMethodNamed: self selector
]

{ #category : #testing }
S2Method >> isNotQuick [
	^ self isQuick not
]

{ #category : #testing }
S2Method >> isNotTest [
	"Return true if the method is not a test method"
	^ self isTest not
]

{ #category : #testing }
S2Method >> isQuick [
	^ originalMethod isQuick
]

{ #category : #comparison }
S2Method >> isReadyForComparison [
	^ self profiler isReadyForComparison
]

{ #category : #testing }
S2Method >> isSpyMethod [
	^ true
]

{ #category : #testing }
S2Method >> isTest [
	"Return true if the original method is defined in a unit test and if the method begins with the word 'test'"
	^ (self asString findString: 'test' startingAt: 0 caseSensitive: true) > 0 and: [ self isInTestCase ]
]

{ #category : #testing }
S2Method >> isUnary [
	^ self selector isUnary
]

{ #category : #'accessing - computed' }
S2Method >> literals [
	^ originalMethod literals
]

{ #category : #'accessing - computed' }
S2Method >> numberOfCalls [
	^ originalMethod messages size
]

{ #category : #'accessing - computed' }
S2Method >> numberOfLinesOfCode [
	^ originalMethod linesOfCode

]

{ #category : #accessing }
S2Method >> originalMethod [
	^ originalMethod
]

{ #category : #accessing }
S2Method >> originalMethod: aCompiledMethod [
	self assert: [ aCompiledMethod isSpy not ].
	originalMethod := aCompiledMethod 
]

{ #category : #accessing }
S2Method >> outgoingCalls [
	^ outgoingCalls ifNil: [ outgoingCalls := self incomingAndOutgoingCallClass new ]
]

{ #category : #'accessing - computed' }
S2Method >> overridingMethods [
	"Return the list of overriding methods"

	^ self classSpy allSubclasses
		select: [ :cls | cls hasMethodNamed: self selector ]
		thenCollect: [ :cls | cls >> self selector ]
]

{ #category : #'accessing - computed' }
S2Method >> package [
	^ self packageSpy
]

{ #category : #'accessing - computed' }
S2Method >> packageSpy [
	^ packageSpy
]

{ #category : #'accessing - computed' }
S2Method >> packageSpy: aPackage [
	packageSpy := aPackage
]

{ #category : #comparison }
S2Method >> previousMethod [
	"Return the previous method"
	| lp cls |
	self assert: [ self profiler isReadyForComparison ] description: 'Cannot be compared, need to send #setForComparison to a profile'.
	
	lp := self profiler lastProfile.
	cls := lp classAt: self classSpy className ifNone: [ ^ false ].
	^ cls >> self selector
]

{ #category : #hooks }
S2Method >> primitiveRun: methodName with: listOfArguments in: receiver [
	| v frame |
	"frame is a critical instance variable, since the S2Context hold WeakReferences, so this variable prevents garbage collection."
	S2Lock isLocked ifTrue: [ ^ originalMethod valueWithReceiver: receiver arguments: listOfArguments ].
	[
		S2Lock lock.
		frame := (S2StackFrame 
								spyMethod: self 
								arguments: listOfArguments 
								receiver: receiver).
		S2Context push: frame.
		self beforeRun: methodName with: listOfArguments in: receiver.
		self classSpy beforeEachExecution: methodName on: receiver with: listOfArguments.
		v := self run: methodName with: listOfArguments in: receiver.
		self returnValue: v.
		self afterRun: methodName with: listOfArguments in: receiver.
		self classSpy afterEachExecution: methodName On: receiver with: listOfArguments.
	] ensure: [ 
		S2Context pop.
		S2Lock unlock.
	 ].

	^ v
]

{ #category : #printing }
S2Method >> printOn: stream [
	self classSpy ifNotNil:[ stream nextPutAll: (self classSpy className asString).].
	stream nextPutAll: ' >> '.
	self selector ifNotNil:[stream nextPutAll: (self selector asString).].
]

{ #category : #'accessing - computed' }
S2Method >> profiler [
	self package ifNil: [ ^ nil ].
	^ self package profiler
]

{ #category : #hooks }
S2Method >> returnValue: value [
]

{ #category : #hooks }
S2Method >> run: methodName with: listOfArguments in: receiver [
	| v |
	[ 
		S2Lock unlock.
		v := originalMethod valueWithReceiver: receiver arguments: listOfArguments.
	] ensure: [ 
		S2Lock lock.
	].
	^ v
]

{ #category : #accessing }
S2Method >> selector [
	^ selector
]

{ #category : #hooks }
S2Method >> selector: sel [
	selector := sel
]

{ #category : #'accessing - computed' }
S2Method >> sender [
	| context|
	context := thisContext.
	[ context sender method isSpy ] whileFalse: [ context := context sender ].
	^ context sender sender method
]

{ #category : #'accessing - computed' }
S2Method >> sourceCode [
	^ originalMethod getSourceFromFile 
]

{ #category : #'accessing - computed' }
S2Method >> spyContext [

	^ self profiler spyContext
]

{ #category : #'accessing - computed' }
S2Method >> spyContextCollection [

	^ self profiler spyContextCollection
]

{ #category : #'accessing - computed' }
S2Method >> spySender [
	"Return the calling spy. Return nil if not found"
	^ self profiler spySender
]

{ #category : #accessing }
S2Method >> staticOutgoingCallsToSelf [
	^ staticOutgoingCalls ifNil: [ staticOutgoingCalls := OrderedCollection new ]
]

{ #category : #accessing }
S2Method >> theClass [
	^ originalMethod methodClass
]

{ #category : #installing }
S2Method >> uninstall [

	self theClass methodDict at: self selector put: self originalMethod.
	self flushCache
]

{ #category : #'accessing - computed' }
S2Method >> withAllOutgoingCalls [
	| answer |
	answer := OrderedCollection new.
	answer add: self.
	self allOutgoingCallsRunning: answer.
	^ answer
]
