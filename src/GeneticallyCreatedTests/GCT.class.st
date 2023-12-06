Class {
	#name : 'GCT',
	#superclass : 'Object',
	#instVars : [
		'random',
		'targetClass',
		'length',
		'chromosome',
		'typeRepository',
		'classesToBeInstantiated',
		'methodNameToExclude'
	],
	#category : 'GeneticallyCreatedTests-Core-CodeGeneration',
	#package : 'GeneticallyCreatedTests',
	#tag : 'Core-CodeGeneration'
}

{ #category : 'building' }
GCT >> addMessageStatement [
	"Add a message statement randomly and correctly created"
	chromosome add: self buildMessageStatement
]

{ #category : 'building' }
GCT >> addMessageStatementVariable: var selector: selector [
	chromosome add: (self buildRawMessageStatementForVariable: var selector: selector)
]

{ #category : 'building' }
GCT >> addObjectCreationStatement [
	chromosome add: self buildObjectCreationStatement
]

{ #category : 'building' }
GCT >> addObjectCreationStatementFor: aClass [
	chromosome add: (self buildObjectCreationStatementFor: aClass)
]

{ #category : 'building' }
GCT >> addStatement [

	^ self addStatementNbTry: 10
]

{ #category : 'building' }
GCT >> addStatementNbTry: nb [
	nb = 0 
		ifTrue: [ 
			(length - chromosome  size) timesRepeat: [ chromosome add: GCTNoStatement new ].
			^ self ].

	[ random next > 0.3
		  ifTrue: [ self addMessageStatement ]
		  ifFalse: [ self addObjectCreationStatement ] 
	] 
		on: CannotCreateStatement 
		do: [ :ex | self addStatementNbTry: (nb - 1) ].
		
]

{ #category : 'initialization' }
GCT >> adjustArguments [

	| newVariables newVariable newVarReceiver candidateVariables |
	
	chromosome doWithIndex: [ :stmt :indexStmt |
		stmt class == GCTMessageStatement ifTrue: [ 
			"self haltIf: [ stmt newVariable == #v6 ]."
			"ADJUST RECEIVER"
			targetClass := stmt receiverType.
			targetClass ~~ (self typeOfVariable: stmt receiver) ifTrue: [
				newVarReceiver := (self
					                   definedVariablesOfType: targetClass
					                   lowerThan: indexStmt) atRandom: random.
				stmt receiver: newVarReceiver ].

			"ADJUST ARGUMENTS"
			newVariables := OrderedCollection new.
			stmt arguments
				with: stmt expectedArgumentTypes
				do: [ :vName :vType |
					(self statementForVariable: vName) type ~~ vType
						ifTrue: [
							candidateVariables := self
								                 definedVariablesOfType: vType
								                 lowerThan: indexStmt.
							candidateVariables ifEmpty: [ ^ nil ].
							newVariable := (candidateVariables copyWithout: vName)
								               atRandom: random.
							newVariables add: newVariable ]
						ifFalse: [ newVariables add: vName ].
					"Could we have a variable as receiver and argument?"
					"self assert: [ (newVariables includes: stmt variable) not ]."
					self assert: [ (newVariables includes: stmt newVariable) not ].
					stmt arguments: newVariables asArray ] ] ].

	self resetObjectExample
]

{ #category : 'building' }
GCT >> buildAssertionsForVariable: v on: s [
		| st vars |
		st := self statementForVariable: v.
		st isSelfEvaluating 
			ifTrue: [ 
				s isSymbol 
					ifTrue: [ s nextPutAll: '	self assert: ', v asString, ' equals: (', st objectExample, ').' ]
					ifFalse: [ s nextPutAll: '	self assert: ', v asString, ' equals: (', st objectExample printString, ').' ].
				s cr ]
			ifFalse: [ 
				"Check for equality between variables"
				vars := (self definedVariablesOfExampleObject: st objectExample) copyWithout: v.
				vars ifNotEmpty: [ 
					vars do: [ :vv |
						s nextPutAll: '	self assert: ', v asString, ' equals: ', vv, '.'.
						s cr 
						 ]
					 ].
				
				"Check for printing"
				st objectExample isString 
					ifTrue: [ 
						st objectExample isSymbol
							ifTrue: [ s nextPutAll: '	self assert: ', v asString, ' printString equals: ''', st objectExample printString, '''.' ]
					 		ifFalse: [ s nextPutAll: '	self assert: ', v asString, ' printString equals: ', st objectExample printString, '.' ] ]
					ifFalse: [ 
						(self shouldClassBeConsideredForAssertion: st objectExample class)
							ifTrue: [ 
								s nextPutAll: '	self assert: ', v asString, ' printString equals: ''', st objectExample printString, '''.' ] ] .
				s cr
				 ]
]

{ #category : 'building' }
GCT >> buildAssertionsOn: s [
	
	self variableLeaves do: [ :v |
		[ self buildAssertionsForVariable: v on: s ] on: Error do: [ :ex | "Cannot create an assertion" ].
			 ]
]

{ #category : 'building' }
GCT >> buildChromosome [

	chromosome := OrderedCollection new.

	self addObjectCreationStatementFor: targetClass.

	length - 1 timesRepeat: [ self addStatement ].
	^ chromosome asArray
]

{ #category : 'building' }
GCT >> buildCode [

	^ String
		streamContents: [ :s |
			self buildCodeOn: s ]

]

{ #category : 'building' }
GCT >> buildCodeOn: s [

	chromosome do: [ :g | g buildCodeOn: s ]

]

{ #category : 'building' }
GCT >> buildCodeWithAssertion [

	^ String
		streamContents: [ :s |
			self buildCodeOn: s.
			self buildAssertionsOn: s ]

]

{ #category : 'building' }
GCT >> buildMessageStatement [
	| vars |
	vars := self definedVariablesOfType: targetClass.
	vars isEmpty ifTrue: [ 
			CannotCreateStatement new 
					messageText: 'Cannot create a new object of targetClass. Need to have some objects of the proper type.'; 
					signal ].
	^ self buildMessageStatementForVariable: (vars atRandom: random)
]

{ #category : 'building' }
GCT >> buildMessageStatementForVariable: aVariable [
	"This method adds one or more statements to send a selector to aVariable. Two situations may happen:
		- If the selector does not have any argument, then creating the MessageStatement is trivial
		- If the selector excepts arguments, then:
				- We look for a variable that has the expected type, or
				- We create a few (1 - 3?) statements (both objectcreation and messages) to create the expected argument"

	"Need to check if the candidate statement already exist. If yes, then we check if the result is the same. If this is the case, then we can assume that the call does not do any side effect, and therefore can be discarded"
	| s |
	1 to: 20 do: [ :i |
		| canCreateExample |
		canCreateExample := true.
		s := self buildRawMessageStatementForVariable: aVariable.
		[ self resetObjectExampleFor: s ] 
			on: CannotCreateStatement 
			do: [ :ex | canCreateExample := false ].
		
		"(s notNil and: [ (self isNewStatement: s) ]) ifTrue: [ ^ s ]"
		(s notNil and: [ canCreateExample ]) ifTrue: [ ^ s ]
	].
	CannotCreateStatement new 
		messageText: 'Cannot create a new message statement'; 
		signal
	
]

{ #category : 'building' }
GCT >> buildObjectCreationStatement [
	^ self buildObjectCreationStatementFor: (classesToBeInstantiated atRandom: random)
]

{ #category : 'building' }
GCT >> buildObjectCreationStatementFor: aClass [
	^ GCTObjectCreationStatement new
			gct: self;
			classToBeInstantiated: aClass;
			newVariable: self newVarName
]

{ #category : 'building' }
GCT >> buildRawMessageStatementForVariable: aVariable [
	"This method adds one or more statements to send a selector to aVariable. Two situations may happen:
		- If the selector does not have any argument, then creating the MessageStatement is trivial
		- If the selector excepts arguments, then:
				- We look for a variable that has the expected type, or
				- We create a few (1 - 3?) statements (both objectcreation and messages) to create the expected argument"

	| s aSelector relevantSelectors |
	s := self statementForVariable: aVariable.
	relevantSelectors := s relevantSelectors copyWithoutAll: methodNameToExclude.
	relevantSelectors ifEmpty: [
		self error: 'Class ' , s type asString
			, ' cannot be tested since it has no method' ].
	aSelector := relevantSelectors atRandom: random.
	
	^ self buildRawMessageStatementForVariable: aVariable selector: aSelector
]

{ #category : 'building' }
GCT >> buildRawMessageStatementForVariable: aVariable selector: aSelector [
	"This method adds one or more statements to send a selector to aVariable. Two situations may happen:
		- If the selector does not have any argument, then creating the MessageStatement is trivial
		- If the selector excepts arguments, then:
				- We look for a variable that has the expected type, or
				- We create a few (1 - 3?) statements (both objectcreation and messages) to create the expected argument"

	| s newObject relevantSelectors numberOfArguments arguments argumentsVariables signature expectedArgumentTypes |
	s := self statementForVariable: aVariable.
	relevantSelectors := s relevantSelectors copyWithoutAll: methodNameToExclude.
	relevantSelectors ifEmpty: [
		self error: 'Class ' , s type asString
			, ' cannot be tested since it has no method' ].
	self assert: [ relevantSelectors includes: aSelector ].

	numberOfArguments := self numberOfArgumentsOfSelector: aSelector.

	numberOfArguments > 0
		ifTrue: [
			targetClass == s objectExample class
				ifFalse: [ ^ nil ].
			signature := typeRepository profiler signatureOf: aSelector.
"OLD:			signature := typeRepository targetClass
				             classNamed: s objectExample class name
				             method: aSelector."
			signature ifNil: [ ^ nil ].
			argumentsVariables := self
				                      pick: numberOfArguments
				                      withTypes: (signature argTypes collect: #name).

			"If we cannot build it, then we simply return nil, to build another statement"
			argumentsVariables ifEmpty: [ ^ nil ].

			arguments := OrderedCollection new.
			argumentsVariables do: [ :v |
				arguments add: (self statementForVariable: v) objectExample ] ]
		ifFalse: [
			arguments := #(  ).
			argumentsVariables := #(  ) ].

	[ newObject := s objectExample
		             perform: aSelector
		             withArguments: arguments asArray ] 
		on: Exception 
		do: [ :ex | 
				 CannotCreateStatement new 
					messageText: 'Cannot create a new message statement'; 
					signal
			].
	expectedArgumentTypes := arguments asArray collect: #class.
	^ GCTMessageStatement new
		  gct: self;
		  newVariable: self newVarName;
		  receiverType: targetClass;
		  expectedArgumentTypes: expectedArgumentTypes;
		  arguments: argumentsVariables;
		  selector: aSelector;
		  receiver: aVariable;
		  objectExample: newObject;
		  type: newObject class;
		  yourself
]

{ #category : 'building' }
GCT >> buildTest [

	^ self buildTestSuffix: ''
]

{ #category : 'building' }
GCT >> buildTestSuffix: aSuffix [
	"self adjustArguments."
	self resetObjectExample.
	^ String
		streamContents: [ :s |
			s << 'testGENERATED'; << aSuffix; cr.
			s << '	| '.
			chromosome do: [ :st | st class ~~ GCTNoStatement ifTrue: [ s << st newVariable << ' ' ] ].
			s << '| '; cr.
			self buildCodeOn: s.
			self buildAssertionsOn: s ]

]

{ #category : 'building' }
GCT >> chromosome [
	^ chromosome
]

{ #category : 'accessing' }
GCT >> chromosome: chromo [
	chromosome := chromo
]

{ #category : 'building' }
GCT >> definedVariables [
	^ (chromosome collect: #newVariable as: Array) copyWithout: nil
]

{ #category : 'accessing - statements' }
GCT >> definedVariablesOfExampleObject: anObject [
	"Useful for building assertions"
	^ (chromosome select: [ :s | s objectExample == anObject ]) collect: #newVariable as: Array
]

{ #category : 'accessing - statements' }
GCT >> definedVariablesOfType: aType [
	self assert: [ aType isBehavior ].
	^ (chromosome select: [ :s | s type == aType ]) collect: #newVariable as: Array
]

{ #category : 'accessing - statements' }
GCT >> definedVariablesOfType: aType lowerThan: aMaxIndex [
	self assert: [ aType isBehavior ].
	
	^ (chromosome withIndexSelect: [ :s :index | s type == aType and: [ index < aMaxIndex ] ]) 
			collect: #newVariable as: Array
	"^ (chromosome select: [ :s | s type == aType ]) collect: #newVariable as: Array"
]

{ #category : 'building' }
GCT >> determineClassesToBeInstantiated [
	| clss |
	clss := typeRepository profiler allClassesUsedAsArguments.
	self assert: [ clss notNil ].
	
	classesToBeInstantiated := OrderedCollection new.
	classesToBeInstantiated addAll: clss.
	classesToBeInstantiated add: targetClass.
	classesToBeInstantiated removeDuplicates.

]

{ #category : 'accessing' }
GCT >> executionScenario: executionScenario [
	self spyRepository: (GCTMethodProxyInstallerType new targetClass: targetClass; run: executionScenario)
]

{ #category : 'initialization' }
GCT >> initialize [
	super initialize.
	length := 2.
	chromosome := OrderedCollection new.
	typeRepository := GCTProvidedTypeRepository new.
	methodNameToExclude := { }
]

{ #category : 'testing' }
GCT >> isNewStatement: aStatement [
	self assert: [ aStatement isKindOf: GCTStatement ].
	^ chromosome noneSatisfy: [ :s | s isSimilarTo: aStatement ]
]

{ #category : 'accessing' }
GCT >> length [

	^ length
]

{ #category : 'accessing' }
GCT >> length: anInteger [
	"Set the length of a chromosome (ie. number of statements in the generated test)"

	length := anInteger
]

{ #category : 'as yet unclassified' }
GCT >> measureCoverage [
	^ self measureCoverageOnClass: GCTTest
]

{ #category : 'as yet unclassified' }
GCT >> measureCoverageOnClass: aClassTest [
	| prof |
	self assert: [ aClassTest isBehavior ].
	aClassTest compile: self buildTest.
	"prof := GCTCoverageProfiler profile: [ aClassTest new perform: #testGENERATED ] onClasses: { targetClass }."
	prof := GCTMethodProxyInstallerCoverage new 
				targetClass: targetClass;
				run: [ aClassTest new perform: #testGENERATED ].
	aClassTest removeSelector: #testGENERATED.
	^ prof coverage
]

{ #category : 'accessing' }
GCT >> methodNameToExclude: methodNames [
	"Set a list of methods name that will not be tested"
	methodNameToExclude := methodNames
]

{ #category : 'building' }
GCT >> newVarName [
	^ ('v', ((chromosome size + 1) asString)) asSymbol
]

{ #category : 'building' }
GCT >> numberOfArgumentsOfSelector: aSelector [

	^ (aSelector select: [ :c | c == $: ]) size
]

{ #category : 'building' }
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

{ #category : 'accessing' }
GCT >> random [

	^ random
]

{ #category : 'accessing' }
GCT >> random: aRandom [

	random := aRandom
]

{ #category : 'initialization' }
GCT >> resetObjectExample [
	chromosome do: [ :stm | self resetObjectExampleFor: stm ].
	
]

{ #category : 'initialization' }
GCT >> resetObjectExampleFor: stm [

	| s arguments newObject |
	stm class == GCTMessageStatement ifTrue: [
		s := self statementForVariable: stm receiver.

		arguments := OrderedCollection new.
		stm arguments do: [ :v |
			arguments add: (self statementForVariable: v) objectExample ].

		[
			newObject := s objectExample
			             perform: stm selector
			             withArguments: arguments asArray ]
			on: Exception
			do: [ :ex |
				CannotCreateStatement new
					messageText: 'Cannot reset an object creation';
					signal ].
		stm objectExample: newObject ].
	
	stm class == GCTObjectCreationStatement ifTrue: [ "May be better something like stm resetObjectExample"
		stm classToBeInstantiated: stm classToBeInstantiated ]
]

{ #category : 'initialization' }
GCT >> resetObjectExampleFor: stm nbTry: nbTry [

	nbTry = 0 ifTrue: [ self error: 'Cannot generate example' ].
	
	 self resetObjectExampleFor: stm 
"	1 to: nbTry do: [ :i |
		| t |
		t := true.
		[ self resetObjectExampleFor: stm ]
			on: CannotCreateStatement do: [ :ex | t := false ].
		t ifTrue:[ ^ self ]
	].
"
]

{ #category : 'initialization' }
GCT >> resetObjectExampleNbTry: nbTry [
	nbTry = 0 ifTrue: [ self error: 'Cannote create examples' ].
	
	[
		chromosome do: [ :stm | self resetObjectExampleFor: stm ].
	] 
		on: CannotCreateStatement 
		do: [ :ex | self resetObjectExampleNbTry: nbTry - 1 ]
]

{ #category : 'building' }
GCT >> shouldClassBeConsideredForAssertion: aClass [
	"Return true if the class deserves to be in assertion. Classes that use hashcode in their printString should be excluded"
	({ Morph } anySatisfy: [ :v | aClass withAllSuperclasses includes: v ]) ifTrue: [ ^ false ].
	^ true
]

{ #category : 'accessing' }
GCT >> spyRepository: aSpyProfiler [
	typeRepository := GCTSpyTypeRepository new profiler: aSpyProfiler.
	self determineClassesToBeInstantiated.
]

{ #category : 'building' }
GCT >> statementForVariable: aSymbol [
	"Return the statement of variable provided as argument"

	^ chromosome detect: [ :tp | tp newVariable == aSymbol ]
]

{ #category : 'accessing' }
GCT >> targetClass [

	^ targetClass
]

{ #category : 'accessing' }
GCT >> targetClass: aPharoClass [

	targetClass := aPharoClass
]

{ #category : 'accessing - variables' }
GCT >> typeOfVariable: aSymbol [

	^ (self statementForVariable: aSymbol) type
]

{ #category : 'accessing' }
GCT >> typeRepository [
	^ typeRepository
]

{ #category : 'accessing' }
GCT >> variableLeaves [
	"Return variables that are not used. Useful when writing the assertions"
	| usedVariables |
	usedVariables := Set new.
	chromosome do: [ :s |
		s class == GCTMessageStatement 
			ifTrue: [ usedVariables addAll: s arguments; add: s receiver ] ].
	^ (self definedVariables copyWithoutAll: usedVariables) asSet asArray asSortedCollection asArray
]

{ #category : 'accessing - variables' }
GCT >> variablesOfType: aSymbol [

	| result |
	result := OrderedCollection new.
	chromosome do: [ :st | 
		st type name == aSymbol ifTrue: [ result add: st newVariable ]
	].
	^ result
]
