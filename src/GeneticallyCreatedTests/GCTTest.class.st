Class {
	#name : 'GCTTest',
	#superclass : 'TestCase',
	#instVars : [
		'gct'
	],
	#category : 'GeneticallyCreatedTests-Tests',
	#package : 'GeneticallyCreatedTests',
	#tag : 'Tests'
}

{ #category : 'running' }
GCTTest >> setUp [
	super setUp.
	gct := GCT new.
	gct random: (Random seed: 42).
	gct targetClass: GCPoint.
	
	gct executionScenario: [  
		| p |
		p := GCPoint new x: 3 y: 10.
		p add: (GCPoint new x: 1 y: 12) ].

"	gct typeRepository
		classNamed: #MyPoint method: #x: argumentsTypes: #(#Number) returnType: #MyPoint;
		classNamed: #MyPoint method: #y: argumentsTypes: #(#Number) returnType: #MyPoint;
		classNamed: #MyPoint method: #add: argumentsTypes: #(#MyPoint) returnType: #MyPoint.
		."
]

{ #category : 'tests' }
GCTTest >> testAdjustArgumentsRaw [
	| genCode |
	gct addObjectCreationStatementFor: GCPoint.
	gct addObjectCreationStatementFor: SmallInteger.
	gct addObjectCreationStatementFor: GCPoint.
	gct addMessageStatementVariable: #v1 selector: #negated.
	gct addMessageStatementVariable: #v4 selector: #x:y:.
	gct addMessageStatementVariable: #v3 selector: #x.
	gct addMessageStatementVariable: #v5 selector: #add:.
	gct addMessageStatementVariable: #v3 selector: #negated.
	gct addMessageStatementVariable: #v3 selector: #y.
	gct addMessageStatementVariable: #v5 selector: #x.
	self assert: gct chromosome size equals: 10.
	
	genCode := gct buildCode.
	self assert: genCode equals: 
'	v1 := GCPoint new.
	v2 := 24.
	v3 := GCPoint new.
	v4 := v1 negated.
	v5 := v4 x: v2 y: v2 .
	v6 := v3 x.
	v7 := v5 add: v4 .
	v8 := v3 negated.
	v9 := v3 y.
	v10 := v5 x.
'.

	gct chromosome at: 2 put: (GCTObjectCreationStatement new gct: gct; classToBeInstantiated: GCPoint; newVariable: #v2).
	gct chromosome at: 3 put: (GCTObjectCreationStatement new gct: gct; classToBeInstantiated: SmallInteger; newVariable: #v3).
	
	gct adjustArguments.

	self deny: gct buildCode equals: genCode.
	self assert: gct buildCode equals:
'	v1 := GCPoint new.
	v2 := GCPoint new.
	v3 := -81.
	v4 := v1 negated.
	v5 := v4 x: v3 y: v3 .
	v6 := v4 x.
	v7 := v5 add: v4 .
	v8 := v7 negated.
	v9 := v8 y.
	v10 := v5 x.
'
	

]

{ #category : 'tests' }
GCTTest >> testCoverage01 [

	| prof |
	prof := GCTMethodProxyInstallerCoverage new targetClass: GCPoint; run: [ 
		| p |
		p := GCPoint new x: 3 y: 10.
		p add: (GCPoint new x: 1 y: 12) ].
	self assert: prof coverage > 0.7
]

{ #category : 'tests' }
GCTTest >> testCreationStatement [
	| obj |
	obj := gct buildObjectCreationStatement.
	self assert: obj class equals: GCTObjectCreationStatement.
	self assert: obj classToBeInstantiated equals: SmallInteger.
	self assert: obj newVariable equals: #v1
]

{ #category : 'tests' }
GCTTest >> testCreationStatement02 [
	| obj |
	gct addObjectCreationStatementFor: GCPoint.
	self assert: gct chromosome size equals: 1.
	
	obj := gct chromosome first.
	self assert: obj newVariable equals: #v1.
	self assert: obj type equals: GCPoint.
	self assert: (gct typeOfVariable: #v1) equals: GCPoint
]

{ #category : 'tests' }
GCTTest >> testCreationStatement03 [
	gct addObjectCreationStatementFor: GCPoint.
	gct addMessageStatement.
	self assert: gct chromosome size equals: 2.
	
	self assert: (gct typeOfVariable: #v1) == GCPoint.
	self assert: (gct statementForVariable: #v1) class == GCTObjectCreationStatement.
	self assert: (gct statementForVariable: #v1) objectExample class == GCPoint.
	self assert: (gct statementForVariable: #v1) type == GCPoint.
	
	self assert: (gct typeOfVariable: #v2) == GCPoint.
	self assert: (gct statementForVariable: #v2) objectExample class == GCPoint.
	
	self assert: (gct definedVariablesOfType: GCPoint) = { #v1 . #v2 }.
	self assert: (gct definedVariablesOfType: SmallInteger) = { }.
	
	self assert: gct buildCode equals: 
'	v1 := GCPoint new.
	v2 := v1 add: v1 .
'
]

{ #category : 'tests' }
GCTTest >> testCreationStatement04 [
	gct addObjectCreationStatementFor: GCPoint.
	gct addMessageStatementVariable: #v1 selector: #y.
	gct addMessageStatementVariable: #v1 selector: #add:.
	gct addMessageStatementVariable: #v1 selector: #x:y:.
	self assert: gct chromosome size equals: 4.
	
	self assert: (gct typeOfVariable: #v1) == GCPoint.
	self assert: (gct typeOfVariable: #v2) == SmallInteger.
	self assert: (gct typeOfVariable: #v3) == GCPoint.
	
	self assert: gct buildCode equals: 
'	v1 := GCPoint new.
	v2 := v1 y.
	v3 := v1 add: v1 .
	v4 := v1 x: v2 y: v2 .
'.

	self assert: gct variableLeaves equals: #(#v3 #v4).
	
	self assert: gct buildCodeWithAssertion equals: 
'	v1 := GCPoint new.
	v2 := v1 y.
	v3 := v1 add: v1 .
	v4 := v1 x: v2 y: v2 .
	self assert: v3 printString equals: ''Point(0,0)''.
	self assert: v4 equals: v1.
	self assert: v4 printString equals: ''Point(0,0)''.
'.

]

{ #category : 'tests' }
GCTTest >> testCreationStatement05 [
	gct addObjectCreationStatementFor: GCPoint.
	gct addMessageStatementVariable: #v1 selector: #y.
	gct addMessageStatementVariable: #v1 selector: #add:.
	gct addMessageStatementVariable: #v1 selector: #x:y:.
	gct addMessageStatementVariable: #v1 selector: #x.
	self assert: gct chromosome size equals: 5.
	
	self assert: (gct typeOfVariable: #v1) == GCPoint.
	self assert: (gct typeOfVariable: #v2) == SmallInteger.
	self assert: (gct typeOfVariable: #v3) == GCPoint.
	
	self assert: gct buildCode equals: 
'	v1 := GCPoint new.
	v2 := v1 y.
	v3 := v1 add: v1 .
	v4 := v1 x: v2 y: v2 .
	v5 := v1 x.
'.

	self assert: gct variableLeaves equals: #(#v3 #v4 #v5).
	
	self assert: gct buildCodeWithAssertion equals: 
'	v1 := GCPoint new.
	v2 := v1 y.
	v3 := v1 add: v1 .
	v4 := v1 x: v2 y: v2 .
	v5 := v1 x.
	self assert: v3 printString equals: ''Point(0,0)''.
	self assert: v4 equals: v1.
	self assert: v4 printString equals: ''Point(0,0)''.
	self assert: v5 equals: (0).
'.

]

{ #category : 'tests' }
GCTTest >> testDefinedVariables [

	self assert: gct definedVariables isEmpty.
	gct addObjectCreationStatement.
	self assert: gct definedVariables equals: { #v1 }.
	
	gct addObjectCreationStatement.
	gct addObjectCreationStatement.
	self assert: gct definedVariables equals: { #v1 . #v2 . #v3}.
]

{ #category : 'tests' }
GCTTest >> testShouldClassBeConsideredForAssertion [

	self assert: (gct shouldClassBeConsideredForAssertion: Point).
	self deny: (gct shouldClassBeConsideredForAssertion: SystemWindow).
	self deny: (gct shouldClassBeConsideredForAssertion: CollapsedMorph)
]
