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
		<< ' := ';
		<< classToBeInstantiated asString;
		<< ' new.';
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
