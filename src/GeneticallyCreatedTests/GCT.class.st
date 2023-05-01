Class {
	#name : #GCT,
	#superclass : #Object,
	#instVars : [
		'random',
		'targetClass',
		'length',
		'chromosome',
		'typeRepository'
	],
	#category : #'GeneticallyCreatedTests-Core'
}

{ #category : #building }
GCT >> addMessageStatement [

	chromosome add: self buildMessageStatement.

]

{ #category : #building }
GCT >> addObjectCreationStatement [
	chromosome add: self buildObjectCreationStatement.
]

{ #category : #building }
GCT >> buildAssertionsOn: s [
	self variableLeaves do: [ :v |
		s nextPutAll: '	self assert: ', v asString, 'printString equals: ''', (self statementForVariable: v) objectExample printString, '''.'.
		s cr ]
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

{ #category : #building }
GCT >> buildCode [

	^ String
		streamContents: [ :s |
			self buildCodeOn: s ]

]

{ #category : #building }
GCT >> buildCodeOn: s [

	chromosome do: [ :g | g buildCodeOn: s ]

]

{ #category : #building }
GCT >> buildCodeWithAssertion [

	^ String
		streamContents: [ :s |
			self buildCodeOn: s.
			self buildAssertionsOn: s ]

]

{ #category : #building }
GCT >> buildMessageStatement [
	^ self buildMessageStatementForVariable: ((self definedVariablesOfType: targetClass) atRandom: random)
]

{ #category : #building }
GCT >> buildMessageStatementForVariable: aVariable [
	"This method adds one or more statements to send a selector to aVariable. Two situations may happen:
		- If the selector does not have any argument, then creating the MessageStatement is trivial
		- If the selector excepts arguments, then:
				- We look for a variable that has the expected type, or
				- We create a few (1 - 3?) statements (both objectcreation and messages) to create the expected argument"

	"Need to check if the candidate statement already exist. If yes, then we check if the result is the same. If this is the case, then we can assume that the call does not do any side effect, and therefore can be discarded"
	| s |
	1 to: 10 do: [ :i |
		s := self buildRawMessageStatementForVariable: aVariable.
		(self isNewStatement: s) ifTrue: [ ^ s ]
	].
	self error: 'Cannot create a new message statement'.
	
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
GCT >> buildRawMessageStatementForVariable: aVariable [
	"This method adds one or more statements to send a selector to aVariable. Two situations may happen:
		- If the selector does not have any argument, then creating the MessageStatement is trivial
		- If the selector excepts arguments, then:
				- We look for a variable that has the expected type, or
				- We create a few (1 - 3?) statements (both objectcreation and messages) to create the expected argument"

	| s aSelector newObject relevantSelectors |
	s := self statementForVariable: aVariable.
	relevantSelectors := s type selectors copyWithoutAll: #(#initialize).
	
	"For now, only test method that do not have any argument"
	"@@@ WILL NEED TO MODIFY THIS SOON"
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
			yourself.
	
]

{ #category : #building }
GCT >> chromosome [
	^ chromosome
]

{ #category : #building }
GCT >> definedVariables [
	^ chromosome collect: #newVariable as: Array
]

{ #category : #accessing }
GCT >> definedVariablesOfType: aType [
	self assert: [ aType isBehavior ].
	^ (chromosome select: [ :s | s type == aType ]) collect: #newVariable as: Array
]

{ #category : #initialization }
GCT >> initialize [
	super initialize.
	length := 2.
	chromosome := OrderedCollection new.
	typeRepository := GCTProvidedTypeRepository new
]

{ #category : #testing }
GCT >> isNewStatement: aStatement [
	self assert: [ aStatement isKindOf: GCTStatement ].
	^ chromosome noneSatisfy: [ :s | s isSimilarTo: aStatement ]
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

{ #category : #accessing }
GCT >> typeRepository [
	^ typeRepository
]

{ #category : #accessing }
GCT >> variableLeaves [
	"Return variables that are not used. Useful when writing the assertions"
	| usedVariables |
	usedVariables := chromosome select: [ :s | s class == GCTMessageStatement ] thenCollect: #variable.
	^ (self definedVariables copyWithoutAll: usedVariables) asSet asArray asSortedCollection asArray
]
