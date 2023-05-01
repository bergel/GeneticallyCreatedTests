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
	self assert: (gct statementForVariable: #v1) class == GCTObjectCreationStatement.
	self assert: (gct statementForVariable: #v1) objectExample class == MyPoint.
	self assert: (gct statementForVariable: #v1) type == MyPoint.
	
	self assert: (gct typeOfVariable: #v2) == SmallInteger.
	self assert: (gct statementForVariable: #v2) objectExample class == SmallInteger.
	
	self assert: (gct definedVariablesOfType: MyPoint) = { #v1 }.
	self assert: (gct definedVariablesOfType: SmallInteger) = { #v2 }.
	
	self assert: gct buildCode equals: 
'	v1 := MyPoint new.
	v2 := v1 y.
'
]

{ #category : #tests }
GCTTest >> testCreationStatement04 [
	gct addObjectCreationStatement.
	gct addMessageStatement.
	gct addMessageStatement.
	gct addMessageStatement.
	self assert: gct chromosome size equals: 4.
	
	self assert: (gct typeOfVariable: #v1) == MyPoint.
	self assert: (gct typeOfVariable: #v2) == SmallInteger.
	
	self assert: gct buildCode equals: 
'	v1 := MyPoint new.
	v2 := v1 y.
	v3 := v1 x.
	v4 := v1 negated.
'.

	self assert: gct variableLeaves equals: #(#v2 #v3 #v4).
	
	self assert: gct buildCodeWithAssertion equals: 
'	v1 := MyPoint new.
	v2 := v1 y.
	v3 := v1 x.
	v4 := v1 negated.
	self assert: v2printString equals: ''0''.
	self assert: v3printString equals: ''0''.
	self assert: v4printString equals: ''a MyPoint''.
'.

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
