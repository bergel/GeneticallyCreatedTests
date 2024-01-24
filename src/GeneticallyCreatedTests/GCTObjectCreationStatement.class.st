Class {
	#name : #GCTObjectCreationStatement,
	#superclass : #GCTStatement,
	#instVars : [
		'classToBeInstantiated',
		'objectBuilders',
		'codeStatement'
	],
	#category : #'GeneticallyCreatedTests-Core-CodeGeneration'
}

{ #category : #accessing }
GCTObjectCreationStatement >> arguments [
	^ #()
]

{ #category : #'as yet unclassified' }
GCTObjectCreationStatement >> buildCodeOn: stream [
	stream 
		<< '	';
		<<	newVariable; 
		<< ' := '.

	stream	 << codeStatement.	 
"	example isSelfEvaluating 
		ifTrue: [ 
			example isSymbol
				ifTrue: [ stream << example printString ]
				ifFalse: [ stream << example asString ].
			 ]
		ifFalse: [ 
			stream	
				<< codeStatement ]."
	stream << '.' << String cr
	
		
]

{ #category : #accessing }
GCTObjectCreationStatement >> classToBeInstantiated [

	^ classToBeInstantiated
]

{ #category : #accessing }
GCTObjectCreationStatement >> classToBeInstantiated: aClass [

	classToBeInstantiated := aClass.
	type := aClass.
	
	"CHECK IF THERE IS A BUILDER"
	(objectBuilders keys includes: aClass) ifTrue: [
		codeStatement := ((objectBuilders at: aClass) atRandom: gct random) value: gct random.
		example := OpalCompiler new source: codeStatement; evaluate.
		^ self
	].
	
	
	"PRIMITIVE VALUES"
	aClass == SmallInteger ifTrue: [ example := (gct random nextInteger: 1000) - 500. codeStatement := example asString. ].
	aClass == Float ifTrue: [ example := (gct random next * 1000) - 500. codeStatement := example asString. ].
	aClass == ByteString ifTrue: [ example := '''' , (ZnMessageBenchmark new randomAsciiString: 5 random: gct random), ''''. codeStatement := example asString. ].
	aClass == ByteSymbol ifTrue: [ example := ((ZnMessageBenchmark new randomAsciiSymbol: 5 random: gct random)) asSymbol. codeStatement := example asString. ].
	
	
	example ifNotNil: [  
		^ self ].
	
	"DEFAULT WAY TO CREATE AN OBJECT"
	example := aClass new.
	codeStatement := aClass name, ' new'.
]

{ #category : #accessing }
GCTObjectCreationStatement >> initialize [
	super initialize.
	objectBuilders := Dictionary new.
	codeStatement := nil
]

{ #category : #testing }
GCTObjectCreationStatement >> isSimilarTo: aStatement [
	^ aStatement isSimilarToObjectCreation: self
]

{ #category : #testing }
GCTObjectCreationStatement >> isSimilarToMessage: aStatement [
	^ false
]

{ #category : #testing }
GCTObjectCreationStatement >> isSimilarToObjectCreation: aStatement [
	^ self classToBeInstantiated == aStatement classToBeInstantiated
]

{ #category : #accessing }
GCTObjectCreationStatement >> objectBuilders: aDictionary [
	"Set a dictionary as object builder"
	self assert: [ aDictionary isDictionary ].
	self assert: [ aDictionary keys allSatisfy: #isBehavior ].
	self assert: [ aDictionary values allSatisfy: #isCollection ].
	objectBuilders := aDictionary
]
