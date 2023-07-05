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
	gct targetClass: GCPoint.
	
	gct spyRepository: (GCTAnalyzer profile: [ 
		| p |
		p := GCPoint new x: 3; y: 10.
		p add: (GCPoint new x: 1; y: 12) ] onClasses: { GCPoint })

"	gct typeRepository
		classNamed: #MyPoint method: #x: argumentsTypes: #(#Number) returnType: #MyPoint;
		classNamed: #MyPoint method: #y: argumentsTypes: #(#Number) returnType: #MyPoint;
		classNamed: #MyPoint method: #add: argumentsTypes: #(#MyPoint) returnType: #MyPoint.
		."
]

{ #category : #tests }
GCTTest >> testAdjustArguments [
	| genCode |
	gct addObjectCreationStatement.
	gct addObjectCreationStatement.
	gct addObjectCreationStatement.
	gct addMessageStatement.
	gct addMessageStatement.
	gct addMessageStatement.
	gct addMessageStatement.
	gct addMessageStatement.
	gct addMessageStatement.
	gct addMessageStatement.
	self assert: gct chromosome size equals: 10.
	
	genCode := gct buildCode.
	self assert: genCode equals: 
'	v1 := TPoint new.
	v2 := 236.
	v3 := TPoint new.
	v4 := v1 negated.
	v5 := v4 y: v2.
	v6 := v3 x.
	v7 := v5 add: v3.
	v8 := v3 negated.
	v9 := v3 y.
	v10 := v5 x.
'.


	gct chromosome at: 2 put: (GCTObjectCreationStatement new gct: gct; classToBeInstantiated: GCPoint; newVariable: #v2).
	gct chromosome at: 3 put: (GCTObjectCreationStatement new gct: gct; classToBeInstantiated: SmallInteger; newVariable: #v3).
	
	gct adjustArguments.

	self deny: gct buildCode equals: genCode.
	self assert: gct buildCode equals:
'	v1 := TPoint new.
	v2 := TPoint new.
	v3 := -266.
	v4 := v1 negated.
	v5 := v4 y: v3.
	v6 := v5 x.
	v7 := v5 add: v2.
	v8 := v4 negated.
	v9 := v4 y.
	v10 := v5 x.
'
	

]

{ #category : #tests }
GCTTest >> testAdjustArguments02 [
	| genCode |
	gct addObjectCreationStatement.
	gct addObjectCreationStatement.
	gct addObjectCreationStatement.
	gct addMessageStatement.
	gct addMessageStatement.
	gct addMessageStatement.
	gct addMessageStatement.
	gct addMessageStatement.
	gct addMessageStatement.
	gct addMessageStatement.
	self assert: gct chromosome size equals: 10.
	
	genCode := gct buildCode.
	self assert: genCode equals: 
'	v1 := TPoint new.
	v2 := 236.
	v3 := TPoint new.
	v4 := v1 negated.
	v5 := v4 y: v2.
	v6 := v3 x.
	v7 := v5 add: v3.
	v8 := v3 negated.
	v9 := v3 y.
	v10 := v5 x.
'.

	gct chromosome at: 1 put: (GCTObjectCreationStatement new gct: gct; classToBeInstantiated: SmallInteger; newVariable: #v1).
	gct chromosome at: 2 put: (GCTObjectCreationStatement new gct: gct; classToBeInstantiated: GCPoint; newVariable: #v2).
	
	
	gct adjustArguments.

	self deny: gct buildCode equals: genCode.
	self assert: gct buildCode equals:
'	v1 := -35.
	v2 := TPoint new.
	v3 := TPoint new.
	v4 := v2 negated.
	v5 := v4 y: v1.
	v6 := v3 x.
	v7 := v5 add: v3.
	v8 := v3 negated.
	v9 := v3 y.
	v10 := v5 x.
'
	

]

{ #category : #tests }
GCTTest >> testCoverage01 [

	| prof |
	prof := GCTCoverageProfiler profile: [ 
		| p |
		p := GCPoint new x: 3; y: 10.
		p add: (GCPoint new x: 1; y: 12) ] onClasses: { GCPoint }.
	self assert: prof coverage > 0.8
]

{ #category : #tests }
GCTTest >> testCreationStatement [
	| obj |
	obj := gct buildObjectCreationStatement.
	self assert: obj class equals: GCTObjectCreationStatement.
	self assert: obj classToBeInstantiated equals: GCPoint.
	self assert: obj newVariable equals: #v1
]

{ #category : #tests }
GCTTest >> testCreationStatement02 [
	| obj |
	gct addObjectCreationStatement.
	self assert: gct chromosome size equals: 1.
	
	obj := gct chromosome first.
	self assert: obj newVariable equals: #v1.
	self assert: obj type equals: GCPoint.
	self assert: (gct typeOfVariable: #v1) equals: GCPoint
]

{ #category : #tests }
GCTTest >> testCreationStatement03 [
	gct addObjectCreationStatement.
	gct addMessageStatement.
	self assert: gct chromosome size equals: 2.
	
	self assert: (gct typeOfVariable: #v1) == GCPoint.
	self assert: (gct statementForVariable: #v1) class == GCTObjectCreationStatement.
	self assert: (gct statementForVariable: #v1) objectExample class == GCPoint.
	self assert: (gct statementForVariable: #v1) type == GCPoint.
	
	self assert: (gct typeOfVariable: #v2) == SmallInteger.
	self assert: (gct statementForVariable: #v2) objectExample class == SmallInteger.
	
	self assert: (gct definedVariablesOfType: GCPoint) = { #v1 }.
	self assert: (gct definedVariablesOfType: SmallInteger) = { #v2 }.
	
	self assert: gct buildCode equals: 
'	v1 := TPoint new.
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
	
	self assert: (gct typeOfVariable: #v1) == GCPoint.
	self assert: (gct typeOfVariable: #v2) == SmallInteger.
	self assert: (gct typeOfVariable: #v3) == GCPoint.
	
	self assert: gct buildCode equals: 
'	v1 := TPoint new.
	v2 := v1 y.
	v3 := v1 x: v2.
	v4 := v3 y: v2.
'.

	self assert: gct variableLeaves equals: #(#v4).
	
	self assert: gct buildCodeWithAssertion equals: 
'	v1 := TPoint new.
	v2 := v1 y.
	v3 := v1 x: v2.
	v4 := v3 y: v2.
	self assert: v4 equals: v1.
	self assert: v4 equals: v3.
	self assert: v4 printString equals: ''a TPoint''.
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
	
	self assert: (gct typeOfVariable: #v1) == GCPoint.
	self assert: (gct typeOfVariable: #v2) == SmallInteger.
	self assert: (gct typeOfVariable: #v3) == GCPoint.
	
	self assert: gct buildCode equals: 
'	v1 := TPoint new.
	v2 := v1 y.
	v3 := v1 x: v2.
	v4 := v3 y: v2.
	v5 := v1 x.
'.

	self assert: gct variableLeaves equals: #(#v4 #v5).
	
	self assert: gct buildCodeWithAssertion equals: 
'	v1 := TPoint new.
	v2 := v1 y.
	v3 := v1 x: v2.
	v4 := v3 y: v2.
	v5 := v1 x.
	self assert: v4 equals: v1.
	self assert: v4 equals: v3.
	self assert: v4 printString equals: ''a TPoint''.
	self assert: v5 equals: (0).
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

{ #category : #tests }
GCTTest >> testShouldClassBeConsideredForAssertion [

	self assert: (gct shouldClassBeConsideredForAssertion: Point).
	self deny: (gct shouldClassBeConsideredForAssertion: SystemWindow).
	self deny: (gct shouldClassBeConsideredForAssertion: CollapsedMorph)
]
