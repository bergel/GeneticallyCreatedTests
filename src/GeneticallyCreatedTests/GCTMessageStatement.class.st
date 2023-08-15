Class {
	#name : #GCTMessageStatement,
	#superclass : #GCTStatement,
	#instVars : [
		'selector',
		'arguments',
		'expectedArgumentTypes',
		'receiver',
		'receiverType'
	],
	#category : #'GeneticallyCreatedTests-Core-CodeGeneration'
}

{ #category : #accessing }
GCTMessageStatement >> arguments [

	^ arguments
]

{ #category : #accessing }
GCTMessageStatement >> arguments: variableArguments [
	self assert: [ variableArguments isCollection ].
	self assert: [ variableArguments allSatisfy: [ :k | k isSymbol ] ].
	"self assert: [ (variableArguments includes: receiver) not ]."
	arguments := variableArguments
]

{ #category : #'as yet unclassified' }
GCTMessageStatement >> buildCodeOn: stream [
	stream 
		<< '	';
		<<	newVariable; 
		<< ' := ';
		<< receiver;
		<< ' '.
	
	(selector includes: $:)
		ifTrue: 
			[	selector keywords doWithIndex: [ :key :anIndex | 
					stream << key.
					stream << ' '.
					stream << (arguments at: anIndex).
					stream << ' '.
				].]
		ifFalse: [ 
			stream << selector ].
	stream 
		<< '.';
		<< String cr.

]

{ #category : #accessing }
GCTMessageStatement >> expectedArgumentTypes [
	^ expectedArgumentTypes
]

{ #category : #accessing }
GCTMessageStatement >> expectedArgumentTypes: someTypes [
	expectedArgumentTypes := someTypes 
	
]

{ #category : #testing }
GCTMessageStatement >> isSelfEvaluating [
	^ example isSelfEvaluating
]

{ #category : #testing }
GCTMessageStatement >> isSimilarTo: aStatement [
	^ aStatement isSimilarToMessage: self
]

{ #category : #testing }
GCTMessageStatement >> isSimilarToMessage: aStatement [
	^ (self variable == aStatement variable) and: [ self selector == aStatement selector ]
]

{ #category : #testing }
GCTMessageStatement >> isSimilarToObjectCreation: aStatement [
	^ false
]

{ #category : #accessing }
GCTMessageStatement >> receiverType [

	^ receiverType
]

{ #category : #accessing }
GCTMessageStatement >> receiverType: aClass [
	self assert: [ aClass isBehavior ].
	receiverType := aClass
]

{ #category : #accessing }
GCTMessageStatement >> selector [

	^ selector
]

{ #category : #accessing }
GCTMessageStatement >> selector: anObject [

	selector := anObject
]

{ #category : #accessing }
GCTMessageStatement >> variable [
	"Return the variable symbol"
	^ receiver
]

{ #category : #accessing }
GCTMessageStatement >> variable: aSymbol [
	"Variable receiver."
	receiver := aSymbol
]
