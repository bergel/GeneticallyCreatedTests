Class {
	#name : #GCTObjectCreationStatement,
	#superclass : #GCTStatement,
	#instVars : [
		'classToBeInstantiated'
	],
	#category : #'GeneticallyCreatedTests-Core'
}

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
