Class {
	#name : #S2SpecialBehaviorPlugin,
	#superclass : #S2ClassPlugin,
	#instVars : [
		'selector',
		'oldMethods',
		'executionBlock',
		'installOnClassSide'
	],
	#category : #'Spy2-Core-Plugins-Class'
}

{ #category : #default }
S2SpecialBehaviorPlugin class >> basicNewPluginOn: aProfiler [

	^ self 
		on: aProfiler 
		forClassSelector: #basicNew 
		executeBlock: [ :profiler :receiver :returnValue | 
			profiler onBasicNew: returnValue ]
]

{ #category : #default }
S2SpecialBehaviorPlugin class >> finalizePluginOn: aProfiler [

	^ self 
		on: aProfiler 
		forSelector: #finalize 
		executeBlock: [ :profiler :receiver :returnValue | 
			profiler onFinalize: receiver]
]

{ #category : #default }
S2SpecialBehaviorPlugin class >> hashPluginOn: aProfiler [

	^ self 
		on: aProfiler 
		forSelector: #hash 
		executeBlock: [ :profiler :receiver :returnValue | 
			profiler hashCallOn: receiver value: returnValue]
]

{ #category : #default }
S2SpecialBehaviorPlugin class >> identityHashPluginOn: aProfiler [

	^ self 
		on: aProfiler 
		forSelector: #identityHash 
		executeBlock: [ :profiler :receiver :returnValue | 
			profiler identityHashCallOn: receiver value: returnValue]
]

{ #category : #'instance creation' }
S2SpecialBehaviorPlugin class >> on: aProfiler forClassSelector: symbol executeBlock: aBlock [
	"block is [ :profiler :receiver :returnValue | ... ]"
	^ (self on: aProfiler)
			selector: symbol;
			executionBlock: aBlock;
			setInstallOnClassSide;
			yourself
]

{ #category : #'instance creation' }
S2SpecialBehaviorPlugin class >> on: aProfiler forSelector: symbol executeBlock: aBlock [
	"block is [ :profiler :receiver :returnValue | ... ]"
	^ (self on: aProfiler)
			selector: symbol;
			executionBlock: aBlock;
			yourself
]

{ #category : #accessing }
S2SpecialBehaviorPlugin >> executionBlock [
	^ executionBlock
]

{ #category : #accessing }
S2SpecialBehaviorPlugin >> executionBlock: aBlock [
	"block is [ :profiler :receiver :returnValue | ... ]"
	executionBlock := aBlock
]

{ #category : #initialization }
S2SpecialBehaviorPlugin >> initialize [
	oldMethods := Dictionary new.
	installOnClassSide := false
]

{ #category : #hooks }
S2SpecialBehaviorPlugin >> installOn: aClass [
	self installOnClassSide 
		ifTrue: [ self rawInstallOn: aClass class ] 
		ifFalse: [ self rawInstallOn: aClass ]
]

{ #category : #accessing }
S2SpecialBehaviorPlugin >> installOnClassSide [
	^ installOnClassSide
]

{ #category : #installing }
S2SpecialBehaviorPlugin >> installOriginalMethodTemplateOn: aClass [
	| originalMethod templateMethod |
	self assert: (oldMethods includesKey: aClass) not.
	
	originalMethod := aClass >> self selector.
	templateMethod := self class >> #tempalteOriginalMethodCall copyFor: aClass.
	
	templateMethod replaceLiterals: { 
		#originalMethod -> originalMethod.
		#spyBlock -> executionBlock.
		#classBeingInstrumented -> aClass.
		#spyProfiler -> self profiler
		 }.
	templateMethod selector: self selector.
	templateMethod responsibleSpy: self.
	oldMethods at: aClass put: originalMethod.
	aClass methodDictionary at: self selector put: templateMethod.
	self selector flushCache.
]

{ #category : #installing }
S2SpecialBehaviorPlugin >> installSuperCallTemplateOn: aClass [
	| templateMethod |
	self assert: (oldMethods includesKey: aClass) not.
	
	templateMethod := self class >> #templateSuperCall copyFor: aClass.
	
	templateMethod replaceLiterals: { 
		#spySelector -> self selector.
		#spyBlock -> executionBlock.
		#classBeingInstrumented -> aClass.
		#spyProfiler -> self profiler
		 }.
	templateMethod selector: self selector.
	templateMethod responsibleSpy: self.
	aClass methodDictionary at: self selector put: templateMethod.
	self selector flushCache.
]

{ #category : #accessing }
S2SpecialBehaviorPlugin >> oldMethods [
	^ oldMethods
]

{ #category : #hooks }
S2SpecialBehaviorPlugin >> priority [
	^ 9999
]

{ #category : #installing }
S2SpecialBehaviorPlugin >> rawInstallOn: aClass [
	(aClass includesSelector: self selector)
		ifTrue: [ self installOriginalMethodTemplateOn: aClass ]
		ifFalse: [ self installSuperCallTemplateOn: aClass ]
]

{ #category : #installing }
S2SpecialBehaviorPlugin >> rawUninstallFrom: aClass [
	oldMethods 
		at: aClass 
		ifPresent: [ :method | 
			aClass methodDict at: self selector put: method.
			oldMethods removeKey: aClass. ] 
		ifAbsent: [ aClass removeSelectorSilently: self selector ]
]

{ #category : #'as yet unclassified' }
S2SpecialBehaviorPlugin >> removeDependant: anObject [
	(anObject isCompiledMethod 
		and: [ anObject selector = selector 
			and: [ (anObject methodClass >> #select) = anObject ]])
				ifTrue: [ self rawUninstallFrom: anObject methodClass ]
]

{ #category : #accessing }
S2SpecialBehaviorPlugin >> selector [
	^ selector
]

{ #category : #accessing }
S2SpecialBehaviorPlugin >> selector: text [
	| symbol |
	symbol := text asSymbol.
	self assert: [ 
		(symbol last = $: 
			and: [ 
				(symbol allButLast splitOn: $:) 
					allSatisfy: [ :txt | txt isNotEmpty] ])
			or: [ (symbol select: [:char | char = $:]) isEmpty ] ].
	selector := symbol
]

{ #category : #initialization }
S2SpecialBehaviorPlugin >> setInstallOnClassSide [
	installOnClassSide := true
]

{ #category : #'private - method template' }
S2SpecialBehaviorPlugin >> tempalteOriginalMethodCall [
	| returnValue |	
	returnValue := #originalMethod valueWithReceiver: self arguments: #().
	self class == #classBeingInstrumented ifTrue: [ 
		[ #spyBlock
			value: #spyProfiler 
			value: self 
			value: returnValue ] spyProtected ].
	^ returnValue
]

{ #category : #'private - method template' }
S2SpecialBehaviorPlugin >> templateSuperCall [
	| returnValue |	
	returnValue := super spySelector.
	self class == #classBeingInstrumented ifTrue: [ 
		[ #spyBlock
			value: #spyProfiler 
			value: self 
			value: returnValue ] spyProtected ].
	^ returnValue
]

{ #category : #hooks }
S2SpecialBehaviorPlugin >> uninstallFrom: aClass [
	self installOnClassSide 
		ifTrue: [ self rawUninstallFrom: aClass class ] 
		ifFalse: [ self rawUninstallFrom: aClass ]
]
