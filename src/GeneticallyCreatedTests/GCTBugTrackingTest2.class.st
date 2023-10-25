Class {
	#name : #GCTBugTrackingTest2,
	#superclass : #TestCase,
	#instVars : [
		'gct'
	],
	#category : #'GeneticallyCreatedTests-Tests'
}

{ #category : #running }
GCTBugTrackingTest2 >> setUp [

	super setUp.
	gct := GCT new.
	gct random: (Random seed: 42).
	gct length: 15.
	gct targetClass: RSGridLayout.

	gct executionScenario: [ 
			| c |
			c := RSCanvas new.
			c add: RSBox new.
			c add: RSBox new.
			RSGridLayout on: c shapes.
			c open delete. ]
]

{ #category : #tests }
GCTBugTrackingTest2 >> testBasic [
	"This test is failing because we do not deal with class methods / constructors"
	| genCode |
	gct addObjectCreationStatement.
gct addObjectCreationStatement.
gct addObjectCreationStatement.
	gct addObjectCreationStatement.
	gct addObjectCreationStatement.
	gct addObjectCreationStatementFor: gct targetClass.
	gct addMessageStatement.
	gct addMessageStatement.
	gct addMessageStatement.
	gct addMessageStatement.
	gct addMessageStatement.
	gct addMessageStatement.
	gct addMessageStatement.
gct addMessageStatement.
gct addMessageStatement.
	self assert: gct chromosome size equals: 15.
	
	genCode := gct buildCode.
]

{ #category : #tests }
GCTBugTrackingTest2 >> testBasic2 [
	"This test is failing because we do not deal with class methods / constructors"
	| fs |
	fs := OrderedCollection new.
	200 timesRepeat: [ 
		gct buildChromosome.
		fs add: (gct measureCoverageOnClass: DummyTest) ].
	fs inspect.
]
