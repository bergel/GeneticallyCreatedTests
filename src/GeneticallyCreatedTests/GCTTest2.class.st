Class {
	#name : #GCTTest2,
	#superclass : #TestCase,
	#instVars : [
		'gct'
	],
	#category : #'GeneticallyCreatedTests-Tests'
}

{ #category : #running }
GCTTest2 >> setUp [

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
GCTTest2 >> testBasic [

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
]
