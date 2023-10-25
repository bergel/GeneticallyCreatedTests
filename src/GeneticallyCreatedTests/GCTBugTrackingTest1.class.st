Class {
	#name : #GCTBugTrackingTest1,
	#superclass : #TestCase,
	#instVars : [
		'gct'
	],
	#category : #'GeneticallyCreatedTests-Tests'
}

{ #category : #running }
GCTBugTrackingTest1 >> setUp [

	super setUp.
	gct := GCT new.
	gct random: (Random seed: 42).
	gct targetClass: GSegment.

	gct spyRepository: (GCTAnalyzer
			 profile: [ 
				 ((RPackageOrganizer default packageNamed: 'Geometry-Tests')
					  definedClasses select: [ :cls | 
					  cls subclasses isEmpty and: [ cls inheritsFrom: TestCase ] ]) 
					 do: [ :cls | cls buildSuite run ] ]
			 onClasses: { GSegment })
]

{ #category : #tests }
GCTBugTrackingTest1 >> testBasic [
	"This test is failing because we do not deal with class methods / constructors"
	<expectedFailure>
	| genCode |
	gct addObjectCreationStatement.
	gct addObjectCreationStatement.
	gct addObjectCreationStatement.
	gct addObjectCreationStatementFor: gct targetClass.
	gct addMessageStatement.
	gct addMessageStatement.
	gct addMessageStatement.
	gct addMessageStatement.
	
	"With the current seed number, the next statement throws an error because GSegment does not have 
	a proper default constructor."
	self shouldnt: [ gct addMessageStatement ] raise: CannotCreateStatement.
	gct addMessageStatement.
	gct addMessageStatement.
	self assert: gct chromosome size equals: 10.
	
	genCode := gct buildCode.
]
