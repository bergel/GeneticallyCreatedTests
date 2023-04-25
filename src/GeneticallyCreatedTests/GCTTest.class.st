Class {
	#name : #GCTTest,
	#superclass : #TestCase,
	#instVars : [
		'gct'
	],
	#category : #'GeneticallyCreatedTests-Core'
}

{ #category : #running }
GCTTest >> setUp [
	super setUp.
	gct := GCT new.
	gct random: (Random seed: 42).
	gct targetClass: MyPoint 
]

{ #category : #tests }
GCTTest >> testCreationStatement [
	| obj |
	obj := gct buildObjectCreationStatement.
	self assert: obj class equals: GCTObjectCreationStatement.
	self assert: obj classToBeInstantiated equals: MyPoint.
	self assert: obj newVariable equals: #v1
]

{ #category : #tests }
GCTTest >> testCreationStatement02 [
	| obj |
	gct addObjectCreationStatement.
	self assert: gct chromosome size equals: 1.
	
	obj := gct chromosome first.
	self assert: obj newVariable equals: #v1.
	self assert: obj type equals: MyPoint.
	self assert: (gct typeOfVariable: #v1) equals: MyPoint
]

{ #category : #tests }
GCTTest >> testCreationStatement03 [
	gct addObjectCreationStatement.
	gct addMessageStatement.
	self assert: gct chromosome size equals: 2.
	
	self assert: (gct typeOfVariable: #v1) == MyPoint.
	self assert: (gct typeOfVariable: #v2) == SmallInteger.
	
	self assert: gct buildCode equals: 
'	v1 := MyPoint new.
	v2 := v1 y.
'
]

{ #category : #tests }
GCTTest >> testDefinedVariables [

	self assert: gct definedVariables isEmpty.
	gct addObjectCreationStatement.
	self assert: gct definedVariables equals: { #v1 }.
	
	gct addObjectCreationStatement.
	gct addObjectCreationStatement.
	self assert: gct definedVariables equals: { #v1 . #v2 . #v3}.
]
