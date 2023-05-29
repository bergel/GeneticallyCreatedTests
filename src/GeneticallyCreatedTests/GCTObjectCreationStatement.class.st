Class {
	#name : #GCTObjectCreationStatement,
	#superclass : #GCTStatement,
	#instVars : [
		'classToBeInstantiated'
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
		 
	objectExample isSelfEvaluating 
		ifTrue: [ 
			stream 
				<< objectExample asString
				<< '.' ]
		ifFalse: [ 
			stream	
				<< classToBeInstantiated asString;
				<< ' new.' ].
		
	stream
		<< String cr
]

{ #category : #accessing }
GCTObjectCreationStatement >> classToBeInstantiated [

	^ classToBeInstantiated
]

{ #category : #accessing }
GCTObjectCreationStatement >> classToBeInstantiated: aClass [

	classToBeInstantiated := aClass.
	type := aClass.
	
	aClass == SmallInteger ifTrue: [ objectExample := (gct random nextInteger: 1000) - 500. ^ self ].
	aClass == Float ifTrue: [ objectExample := (gct random next * 1000) - 500. ^ self ].
	objectExample := aClass new
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
