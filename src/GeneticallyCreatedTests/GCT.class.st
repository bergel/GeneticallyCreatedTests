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
	#category : #'GeneticallyCreatedTests-Core-CodeGeneration'
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
	| vars |
	self variableLeaves do: [ :v |
		| st |
		st := self statementForVariable: v.
		
		st isSelfEvaluating 
			ifTrue: [ 
				s nextPutAll: '	self assert: ', v asString, ' equals: ', st objectExample printString, '.'.
				s cr ]
			ifFalse: [ 
				vars := (self definedVariablesOfExampleObject: st objectExample) copyWithout: v.
				vars ifNotEmpty: [ 
					vars do: [ :vv |
						s nextPutAll: '	self assert: ', v asString, ' equals: ', vv, '.'.
						s cr 
						 ]
					 ]
				 ]
			 ]
]

{ #category : #building }
GCT >> buildChromosome [
	chromosome := OrderedCollection new.
	
	self addObjectCreationStatement.

	length - 1 timesRepeat: [ 
		random next > 0.3
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
		(s notNil and: [ (self isNewStatement: s) ]) ifTrue: [ ^ s ]
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

	| s aSelector newObject relevantSelectors numberOfArguments arguments argumentsVariables signature |
	s := self statementForVariable: aVariable.
	relevantSelectors := s relevantSelectors.
	relevantSelectors ifEmpty: [ 
		self error: 'Class ' , s type asString
			, ' cannot be tested since it has no method' ].
	
	aSelector := relevantSelectors atRandom: random.
	[ (typeRepository classNamed: s objectExample class name method: aSelector) isNil ] 
		whileTrue: [ aSelector := relevantSelectors atRandom: random ].
		
	numberOfArguments := self numberOfArgumentsOfSelector: aSelector.

	numberOfArguments > 0
		ifTrue: [ 
			signature := typeRepository
				             classNamed: s objectExample class name
				             method: aSelector.
			argumentsVariables := self
				                      pick: numberOfArguments
				                      withTypes: signature third.

			"If we cannot build it, then we simply return nil, to build another statement"
			argumentsVariables ifEmpty: [ ^ nil ].

			arguments := OrderedCollection new.
			argumentsVariables do: [ :v | 
				arguments add: (self statementForVariable: v) objectExample ] ]
		ifFalse: [ 
			arguments := #(  ).
			argumentsVariables := #(  ) ].

	newObject := s objectExample
		             perform: aSelector
		             withArguments: arguments asArray.
	^ GCTMessageStatement new
		  newVariable: self newVarName;
		  arguments: argumentsVariables;
		  selector: aSelector;
		  variable: aVariable;
		  objectExample: newObject;
		  type: newObject class;
		  yourself
]

{ #category : #building }
GCT >> chromosome [
	^ chromosome
]

{ #category : #accessing }
GCT >> chromosome: chromo [
	chromosome := chromo
]

{ #category : #building }
GCT >> definedVariables [
	^ chromosome collect: #newVariable as: Array
]

{ #category : #'accessing - statements' }
GCT >> definedVariablesOfExampleObject: anObject [
	^ (chromosome select: [ :s | s objectExample == anObject ]) collect: #newVariable as: Array
]

{ #category : #'accessing - statements' }
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
GCT >> length: anInteger [
	"Set the length of a chromosome (ie. number of statements in the generated test)"

	length := anInteger
]

{ #category : #'as yet unclassified' }
GCT >> measureCoverage [
	| prof |
	GCTTest compile: 'testGENERATED', String cr, self buildCodeWithAssertion.
	prof := GCTCoverageProfiler profile: [ GCTTest new testGENERATED ] onClasses: { targetClass }.
	^ prof coverage
]

{ #category : #'as yet unclassified' }
GCT >> measureCoverageOnClass: aClassTest [
	| prof |
	aClassTest compile: 'testGENERATED', String cr, self buildCodeWithAssertion.
	prof := GCTCoverageProfiler profile: [ aClassTest new testGENERATED ] onClasses: { targetClass }.
	^ prof coverage
]

{ #category : #building }
GCT >> newVarName [
	^ ('v', ((chromosome size + 1) asString)) asSymbol
]

{ #category : #building }
GCT >> numberOfArgumentsOfSelector: aSelector [

	^ (aSelector select: [ :c | c == $: ]) size
]

{ #category : #building }
GCT >> pick: numberOfArguments withTypes: someTypes [
	"someTypes is not used for now"
	| result vs |
	self assert: [ someTypes isCollection ].
	self assert: [ someTypes allSatisfy: #isSymbol ].
	
	result := OrderedCollection new.
	1 to: numberOfArguments do: [ :i |
		vs := self variablesOfType: (someTypes at: i).
		
		"We cannot build the statement. Let's build another"
		vs ifEmpty: [ ^ #() ].
		
		result add: (vs atRandom: random)
	].
	"
	vs := self definedVariables copy.
	result := OrderedCollection new.
	numberOfArguments timesRepeat: [ 
		i := random nextInteger: vs size.
		result add: (vs at: i).
		vs := vs copyWithout: (vs at: i)
		 ]."
	^ result
]

{ #category : #accessing }
GCT >> random [

	^ random
]

{ #category : #accessing }
GCT >> random: aRandom [

	random := aRandom
]

{ #category : #accessing }
GCT >> spyRepository: aSpyProfiler [
	typeRepository := GCTSpyTypeRepository new profiler: aSpyProfiler
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

{ #category : #'accessing - variables' }
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
	usedVariables := Set new.
	chromosome do: [ :s |
		s class == GCTMessageStatement 
			ifTrue: [ usedVariables addAll: s arguments; add: s variable ] ].
	^ (self definedVariables copyWithoutAll: usedVariables) asSet asArray asSortedCollection asArray
]

{ #category : #'accessing - variables' }
GCT >> variablesOfType: aSymbol [

	| result |
	result := OrderedCollection new.
	chromosome do: [ :st | 
		st type name == aSymbol ifTrue: [ result add: st newVariable ]
	].
	^ result
]
