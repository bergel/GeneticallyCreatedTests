Class {
	#name : #GCT,
	#superclass : #Object,
	#instVars : [
		'random',
		'targetClass',
		'length',
		'chromosome'
	],
	#category : #'GeneticallyCreatedTests-Core'
}

{ #category : #building }
GCT >> addMessageStatement [

	| obj |
	chromosome add: self buildMessageStatement.

	"We now need to know what is the type of the added message statement"
	"obj := self executeStatement: chromosome last.
	chromosomeType add: obj class."
]

{ #category : #building }
GCT >> addObjectCreationStatement [
	chromosome add: self buildObjectCreationStatement.
]

{ #category : #building }
GCT >> buildChromosome [

	self addObjectCreationStatement.

	length - 1 timesRepeat: [ 
		random next > 0.5
			ifTrue: [ self addMessageStatement ]
			ifFalse: [ self addObjectCreationStatement ] ].
	^ chromosome asArray
]

{ #category : #'as yet unclassified' }
GCT >> buildCode [

	^ String
		streamContents: [ :s |
			chromosome do: [ :g | g buildCodeOn: s ] ]

]

{ #category : #building }
GCT >> buildMessageStatement [
	^ self buildMessageStatementForVariable: (self definedVariables atRandom: random)
]

{ #category : #building }
GCT >> buildMessageStatementForVariable: aVariable [
	| s aSelector newObject relevantSelectors |
	s := self statementForVariable: aVariable.
	relevantSelectors := s type selectors copyWithoutAll: #(#initialize).
	
	"For now, only test method that do not have any argument"
	relevantSelectors := relevantSelectors reject: [ :k | (k includes: $:) ].
	
	relevantSelectors ifEmpty: [ self error: ('Class ', s type asString, ' cannot be tested since it has no method') ].
	aSelector := relevantSelectors atRandom: random.
	newObject := s objectExample perform: aSelector.
	^ GCTMessageStatement new
			newVariable: self newVarName;
			selector: aSelector;
			variable: aVariable;
			objectExample: newObject;
			type: newObject class;
			yourself
			
			
]

{ #category : #building }
GCT >> buildObjectCreationStatement [
	^ self buildObjectCreationStatementFor: targetClass
]

{ #category : #building }
GCT >> buildObjectCreationStatementFor: aClass [
	^ GCTObjectCreationStatement new
			classToBeInstantiated: aClass;
			newVariable: self newVarName
]

{ #category : #building }
GCT >> chromosome [
	^ chromosome
]

{ #category : #building }
GCT >> definedVariables [
	^ chromosome collect: #newVariable as: Array
]

{ #category : #initialization }
GCT >> initialize [
	super initialize.
	length := 2.
	chromosome := OrderedCollection new.
	
]

{ #category : #accessing }
GCT >> length [

	^ length
]

{ #category : #accessing }
GCT >> length: anObject [

	length := anObject
]

{ #category : #building }
GCT >> newVarName [
	^ ('v', ((chromosome size + 1) asString)) asSymbol
]

{ #category : #accessing }
GCT >> random [

	^ random
]

{ #category : #accessing }
GCT >> random: aRandom [

	random := aRandom
]

{ #category : #building }
GCT >> statementForVariable: aSymbol [

	^ chromosome detect: [ :tp | tp newVariable == aSymbol ]
]

{ #category : #accessing }
GCT >> targetClass [

	^ targetClass
]

{ #category : #accessing }
GCT >> targetClass: aPharoClass [

	targetClass := aPharoClass
]

{ #category : #building }
GCT >> typeOfVariable: aSymbol [

	^ (self statementForVariable: aSymbol) type
]
