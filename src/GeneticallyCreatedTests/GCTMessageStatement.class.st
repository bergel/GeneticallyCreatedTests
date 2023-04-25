Class {
	#name : #GCTMessageStatement,
	#superclass : #GCTStatement,
	#instVars : [
		'variable',
		'selector',
		'arguments'
	],
	#category : #'GeneticallyCreatedTests-Core'
}

{ #category : #accessing }
GCTMessageStatement >> arguments [

	^ arguments
]

{ #category : #accessing }
GCTMessageStatement >> arguments: anObject [

	arguments := anObject
]

{ #category : #'as yet unclassified' }
GCTMessageStatement >> buildCodeOn: stream [
	stream 
		<< '	';
		<<	newVariable; 
		<< ' := ';
		<< variable;
		<< ' ';
		<< selector;
		<< '.';
		<< String cr.
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

	^ variable
]

{ #category : #accessing }
GCTMessageStatement >> variable: anObject [

	variable := anObject
]
