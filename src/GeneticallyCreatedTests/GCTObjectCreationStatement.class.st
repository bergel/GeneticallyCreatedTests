Class {
	#name : 'GCTObjectCreationStatement',
	#superclass : 'GCTStatement',
	#instVars : [
		'classToBeInstantiated'
	],
	#category : 'GeneticallyCreatedTests-Core-CodeGeneration',
	#package : 'GeneticallyCreatedTests',
	#tag : 'Core-CodeGeneration'
}

{ #category : 'accessing' }
GCTObjectCreationStatement >> arguments [
	^ #()
]

{ #category : 'as yet unclassified' }
GCTObjectCreationStatement >> buildCodeOn: stream [
	stream 
		<< '	';
		<<	newVariable; 
		<< ' := '.
		 
	example isSelfEvaluating 
		ifTrue: [ 
			example isSymbol
				ifTrue: [ stream << example printString ]
				ifFalse: [ stream << example asString ].
			stream << '.'
			 ]
		ifFalse: [ 
			stream	
				<< classToBeInstantiated asString;
				<< ' new.' ].
		
	stream
		<< String cr
]

{ #category : 'accessing' }
GCTObjectCreationStatement >> classToBeInstantiated [

	^ classToBeInstantiated
]

{ #category : 'accessing' }
GCTObjectCreationStatement >> classToBeInstantiated: aClass [

	classToBeInstantiated := aClass.
	type := aClass.
	
	aClass == SmallInteger ifTrue: [ example := (gct random nextInteger: 1000) - 500. ^ self ].
	aClass == Float ifTrue: [ example := (gct random next * 1000) - 500. ^ self ].
	aClass == ByteString ifTrue: [ example := '''' , (ZnMessageBenchmark new randomAsciiString: 5 random: gct random), ''''. ^ self ].
	aClass == ByteSymbol ifTrue: [ example := ((ZnMessageBenchmark new randomAsciiSymbol: 5 random: gct random)) asSymbol. ^ self ].
	
	example := aClass new
]

{ #category : 'testing' }
GCTObjectCreationStatement >> isSimilarTo: aStatement [
	^ aStatement isSimilarToObjectCreation: self
]

{ #category : 'testing' }
GCTObjectCreationStatement >> isSimilarToMessage: aStatement [
	^ false
]

{ #category : 'testing' }
GCTObjectCreationStatement >> isSimilarToObjectCreation: aStatement [
	^ self classToBeInstantiated == aStatement classToBeInstantiated
]
