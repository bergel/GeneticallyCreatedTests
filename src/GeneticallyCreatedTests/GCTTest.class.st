Class {
	#name : #GCTTest,
	#superclass : #TestCase,
	#instVars : [
		'gct'
	],
	#category : #'GeneticallyCreatedTests-Tests'
}

{ #category : #running }
GCTTest >> setUp [
	super setUp.
	gct := GCT new.
	gct random: (Random seed: 42).
	gct targetClass: MyPoint.
	
	gct spyRepository: (GCTAnalyzer profile: [ 
		| p |
		p := MyPoint new x: 3; y: 10.
		p add: (MyPoint new x: 1; y: 12) ] onClasses: { MyPoint })

"	gct typeRepository
		classNamed: #MyPoint method: #x: argumentsTypes: #(#Number) returnType: #MyPoint;
		classNamed: #MyPoint method: #y: argumentsTypes: #(#Number) returnType: #MyPoint;
		classNamed: #MyPoint method: #add: argumentsTypes: #(#MyPoint) returnType: #MyPoint.
		."
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
	
	self assert: (gct typeOfVariable: #v2) == MyPoint.
	self assert: (gct statementForVariable: #v2) objectExample class == MyPoint.
	
	self assert: (gct definedVariablesOfType: MyPoint) = { #v1 . #v2}.
	self assert: (gct definedVariablesOfType: SmallInteger) isEmpty.
	
	self assert: gct buildCode equals: 
'	v1 := MyPoint new.
	v2 := v1 negated.
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
	self assert: (gct typeOfVariable: #v2) == MyPoint.
	self assert: (gct typeOfVariable: #v3) == SmallInteger.
	
	self assert: gct buildCode equals: 
'	v1 := MyPoint new.
	v2 := v1 negated.
	v3 := v1 y.
	v4 := v1 x: v3.
'.

	self assert: gct variableLeaves equals: #(#v2 #v4).
	
	self assert: gct buildCodeWithAssertion equals: 
'	v1 := MyPoint new.
	v2 := v1 negated.
	v3 := v1 y.
	v4 := v1 x: v3.
	self assert: v4 equals: v1.
'.

]

{ #category : #tests }
GCTTest >> testCreationStatement05 [
	gct addObjectCreationStatement.
	gct addMessageStatement.
	gct addMessageStatement.
	gct addMessageStatement.
	gct addMessageStatement.
	self assert: gct chromosome size equals: 5.
	
	self assert: (gct typeOfVariable: #v1) == MyPoint.
	self assert: (gct typeOfVariable: #v2) == MyPoint.
	self assert: (gct typeOfVariable: #v3) == SmallInteger.
	
	self assert: gct buildCode equals: 
'	v1 := MyPoint new.
	v2 := v1 negated.
	v3 := v1 y.
	v4 := v1 x: v3.
	v5 := v2 x.
'.

	self assert: gct variableLeaves equals: #(#v4 #v5).
	
	self assert: gct buildCodeWithAssertion equals: 
'	v1 := MyPoint new.
	v2 := v1 negated.
	v3 := v1 y.
	v4 := v1 x: v3.
	v5 := v2 x.
	self assert: v4 equals: v1.
	self assert: v5 equals: 0.
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
