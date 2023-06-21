Class {
	#name : #S2Package,
	#superclass : #Spy2,
	#instVars : [
		'packageName',
		'classes',
		'classExtensions',
		'metaclassExtensions',
		'profiler'
	],
	#category : #'Spy2-Core-Metamodel'
}

{ #category : #hooks }
S2Package class >> spyClassForClass [
	^ S2Class
]

{ #category : #accessing }
S2Package >> >> aSymbol [
	(aSymbol includes: $ ) ifTrue: [ ^ (self >> aSymbol substrings first asSymbol) metaclassSpy ].
	
	^ self classAt: aSymbol
]

{ #category : #accessing }
S2Package >> addMethod: spyMethod [
	spyMethod classSpy package = self ifTrue: [ ^ self ].
	spyMethod classSpy isMeta
				ifFalse: [ self classExtensions add: spyMethod ]
				ifTrue: [ self metaclassExtensions add: spyMethod ]
]

{ #category : #accessing }
S2Package >> allClasses [
	^ classes values
]

{ #category : #enumerating }
S2Package >> allClassesSuchThat: aBlock [
	^ self classes select: aBlock
]

{ #category : #'accessing-computed' }
S2Package >> allMethods [
	| coll |
	coll := OrderedCollection new.
	self classes do: [:cls | 
		coll addAll: cls methods. 
		coll addAll: cls metaclassSpy methods ].
	^ coll
]

{ #category : #enumerating }
S2Package >> allMethodsSuchThat: aBlock [
	^ self allMethods select: aBlock
]

{ #category : #accessing }
S2Package >> classAt: aSymbol [
	^ classes at: aSymbol ifAbsent: [ self error: 'Class ', aSymbol, ' not found']
]

{ #category : #accessing }
S2Package >> classAt: aSymbol ifNone: aBlock [
	^ classes at: aSymbol ifAbsent: aBlock
	
]

{ #category : #accessing }
S2Package >> classAt: aSymbol put: aClassType [
	self assert: [aSymbol isSymbol].
	
	aClassType className: aSymbol.
	^ classes at: aSymbol put: aClassType
]

{ #category : #accessing }
S2Package >> classExtensions [
	^ classExtensions
]

{ #category : #accessing }
S2Package >> classes [ 
	^ classes values
]

{ #category : #enumerating }
S2Package >> classesDo: aBlockOrSymbol [
	^ classes do: aBlockOrSymbol
]

{ #category : #testing }
S2Package >> hasClassNamed: className [
	^ self classes includesKey: className asSymbol
]

{ #category : #initialization }
S2Package >> initialize [ 
	super initialize.
	classes := Dictionary new.
	classExtensions := OrderedCollection new.
	metaclassExtensions := OrderedCollection new
]

{ #category : #accessing }
S2Package >> metaclassExtensions [
	^ metaclassExtensions
]

{ #category : #accessing }
S2Package >> packageName [
	^ packageName
]

{ #category : #accessing }
S2Package >> packageName: nameAsString [
	packageName  := nameAsString asString
]

{ #category : #printing }
S2Package >> printOn: stream [
	stream nextPut: $<.
	self packageName ifNotNil:
		[ stream nextPutAll: 'P:'. 
		  stream nextPutAll: (self packageName) ].
	stream nextPut: $>
]

{ #category : #accessing }
S2Package >> profiler [
	^ profiler
]

{ #category : #accessing }
S2Package >> profiler: anObject [
	profiler := anObject
]
