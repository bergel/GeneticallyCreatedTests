Class {
	#name : #S2Class,
	#superclass : #Spy2,
	#instVars : [
		'methods',
		'className',
		'allSubclassesCache',
		'packageSpy',
		'metaclassSpy'
	],
	#category : #'GeneticallyCreatedTests-ProfilingFramework-Spy'
}

{ #category : #hooks }
S2Class class >> spyClassForMethod [
	^ S2Method 
]

{ #category : #'accessing - computed' }
S2Class >> >> aSymbol [
	^ self localMethodAt: aSymbol
]

{ #category : #hooks }
S2Class >> afterEachExecution: messageName On: aReceiver with: arguments [
]

{ #category : #hooks }
S2Class >> afterEachExecution: messageName on: aReceiver with: arguments [
]

{ #category : #'accessing - computed' }
S2Class >> allMethods [
	"Return spy methods for baseclass and metaclass"
	^ self baseclassSpy methods , self metaclassSpy methods
]

{ #category : #'accessing - computed' }
S2Class >> allSubclasses [
	allSubclassesCache ifNotNil: [ ^ allSubclassesCache ].
	^ allSubclassesCache := self subclasses inject: #() into: [:sum :cls | sum, {cls}, cls allSubclasses ]
]

{ #category : #'accessing - computed' }
S2Class >> baseclassSpy [
	^ self theClass instanceSide getSpy: self profiler
]

{ #category : #hooks }
S2Class >> beforeEachExecution: messageName on: aReceiver with: arguments [
]

{ #category : #action }
S2Class >> browse [
	self theClass browse
]

{ #category : #accessing }
S2Class >> className [
	"Return the name of the Pharo class"
	^ className
]

{ #category : #accessing }
S2Class >> className: aSymbol [
	className := aSymbol
]

{ #category : #'accessing - computed' }
S2Class >> classWithMetaclass [ 
	^ {self baseclassSpy . self metaclassSpy}
]

{ #category : #'accessing - computed' }
S2Class >> downwardLookupMethodsNamed: aSelector [
	^ (self allSubclasses select: [:cls | cls hasMethodNamed: aSelector])
			collect: [:cls | cls localMethodAt: aSelector ]
		
]

{ #category : #'accessing - computed' }
S2Class >> hasLocalMethod: aSelector [

	^ methods includesKey: aSelector
]

{ #category : #testing }
S2Class >> hasMethodNamed: aSelector [
	^ self localMethods includesKey: aSelector
]

{ #category : #testing }
S2Class >> hasSubclasses [
	^ self allSubclasses notEmpty
]

{ #category : #initialization }
S2Class >> initialize [ 
	super initialize.
	 methods := Dictionary new 
]

{ #category : #testing }
S2Class >> isAbstract [
	"Return true if the real class is a test case"
	
	^ self theClass isAbstract.
]

{ #category : #testing }
S2Class >> isClassPresent [
	^ Smalltalk globals includesKey: className 
]

{ #category : #testing }
S2Class >> isMeta [
	^ self className includes: $ .
]

{ #category : #testing }
S2Class >> isSubclassOf: aClassSpy [
	"True of I am a subclass of aClassSpy"
	aClassSpy ifNil: [ false ].
	self superclass ifNil: [ ^ false ].
	^ self superclass == aClassSpy
		ifTrue: [ true ]
		ifFalse: [ self superclass isSubclassOf: aClassSpy ]
]

{ #category : #testing }
S2Class >> isSuperclassOf: aClassSpy [
	"True of I am a subclass of aClassSpy"
	(aClassSpy isNil or: [ aClassSpy == self ])
		ifTrue: [ ^ false ].
	^ aClassSpy isSubclassOf: self
]

{ #category : #testing }
S2Class >> isTestClass [
	"Return true if the real class is a test case"
	
	^ self theClass inheritsFrom: TestCase.
]

{ #category : #'accessing - computed' }
S2Class >> localMethodAt: aSelector [
	^ self localMethods at: aSelector
]

{ #category : #'accessing - computed' }
S2Class >> localMethodAt: aSelector ifAbsent: aBlock [
	^ self localMethods at: aSelector ifAbsent: aBlock
]

{ #category : #'accessing - computed' }
S2Class >> localMethodAt: aSelector put:  value [
	^ self localMethods at: aSelector put: value
]

{ #category : #accessing }
S2Class >> localMethods [
	^ methods 
]

{ #category : #'accessing - computed' }
S2Class >> lookupMethodNamed: aSelector [
	^ (self hasMethodNamed: aSelector)
			ifTrue: [ self localMethodAt: aSelector ]
			ifFalse: [ self superclass lookupMethodNamed: aSelector ]
]

{ #category : #accessing }
S2Class >> metaclassSpy [
	self isMeta ifTrue: [ ^ self ].
	^ metaclassSpy
]

{ #category : #accessing }
S2Class >> metaclassSpy: s2class [
	metaclassSpy := s2class
]

{ #category : #'accessing - computed' }
S2Class >> methods [ 
	"Return spy methods I directly define. The spy methods of my meta class are not returned"
	^ methods values
]

{ #category : #'accessing - computed' }
S2Class >> nonMetaClassName [
	^ (self isMeta
		ifTrue: [ self className copyFrom: 1 to: ((self className indexOf: $ ) - 1)] 
		ifFalse: [ self className ]) asSymbol
]

{ #category : #'accessing - computed' }
S2Class >> numberOfAllMethods [
	^ self allMethods size
]

{ #category : #'accessing - computed' }
S2Class >> numberOfCoveredMethods [
	^ self coveredMethods size
]

{ #category : #'accessing - computed' }
S2Class >> numberOfMethods [
	^ self methods size
]

{ #category : #accessing }
S2Class >> package [
	^ self packageSpy
]

{ #category : #accessing }
S2Class >> packageSpy [
	^ packageSpy
]

{ #category : #accessing }
S2Class >> packageSpy: anObject [ 
	packageSpy := anObject
]

{ #category : #printing }
S2Class >> printOn: stream [
	stream nextPutAll: self className asString.
]

{ #category : #'accessing - computed' }
S2Class >> profiler [
	^ self package profiler
]

{ #category : #'accessing - computed' }
S2Class >> subclasses [
	^ self profiler allClassesSuchThat: [:cls | cls superclass == self]
]

{ #category : #accessing }
S2Class >> superclass [
	^ self profiler classAt: self theClass superclass name ifNone: [nil]
]

{ #category : #accessing }
S2Class >> theClass [
	"Return the Pharo class behind the class spy"
	^ self isMeta
		ifTrue: [ (Smalltalk at: self nonMetaClassName) class ]
		ifFalse: [ Smalltalk at: self className ]
]

{ #category : #'accessing - computed' }
S2Class >> theNonMetaClass [ 
	"Return the non metaclass spy for the receiver"
	
	self isMeta ifFalse: [ ^ self ].
	^ self packageSpy >> self nonMetaClassName
]

{ #category : #'accessing - computed' }
S2Class >> withAllSubclasses [
	^ self allSubclasses , { self }
]
