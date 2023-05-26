Class {
	#name : #SmallEvoTest,
	#superclass : #Object,
	#instVars : [
		'chromosomeLength',
		'populationSize',
		'targetClass',
		'executionScenario',
		'generateTestNamed'
	],
	#category : #'GeneticallyCreatedTests-Core-Evolution'
}

{ #category : #accessing }
SmallEvoTest >> executionScenario: aBlock [
	executionScenario := aBlock 
]

{ #category : #accessing }
SmallEvoTest >> generateTestNamed: aSymbol [
	"Set the name of the unit test to be generated"
	generateTestNamed := aSymbol
]

{ #category : #initialization }
SmallEvoTest >> initialize [
	super initialize.
	chromosomeLength := 4.
	populationSize := 5.
	targetClass := nil. "Need to be manually set!"
	executionScenario := [  ]
]

{ #category : #running }
SmallEvoTest >> run [
	| g indCache gct |
	self assert: [ targetClass notNil ].
	
	"-------"
	gct := GCT new.
	gct random: (Random seed: 42).
	gct targetClass: targetClass.
	
	gct spyRepository: (GCTAnalyzer profile: executionScenario onClasses: { targetClass }).

	gct length: chromosomeLength.	
	gct buildChromosome.
	"-------"
	
	g := GAEngine new.
	g populationSize: populationSize.
	g numberOfGenes: chromosomeLength.
	
	indCache := Dictionary new.
	g createGeneBlock: [ :rand :index :ind | 
		(indCache includesKey: ind) ifFalse: [ gct buildChromosome. indCache at: ind put: gct chromosome. ].
		(indCache at: ind) atRandom: rand ].
	
	g fitnessBlock: [ :genes | 
			GCT new 
				chromosome: genes; 
				targetClass: gct targetClass; 
				measureCoverageOnClass: self testClassUnderGeneration ].
		
	g run.
	
	self halt.
	"TO INSPECT:"
	(GCT new chromosome: g logs first fittestIndividual genes) buildCodeWithAssertion.
	g logs collect: [ :l | l fittestIndividual fitness ].
	
]

{ #category : #running }
SmallEvoTest >> runRSCanvas [
	"
	self new runRSCanvas
	"
	| g chromosomeLength indCache gct |
	chromosomeLength := 4.
	
	"-------"
	gct := GCT new.
	gct random: (Random seed: 42).
	gct targetClass: RSCanvas.
	
	gct spyRepository: (GCTAnalyzer profile: [ 
		| c |
		c := RSCanvas new.
		c add: RSBox new.
		c add: RSBox new.
		RSGridLayout on: c shapes.
		c open delete. ] onClasses: { RSCanvas }).

	gct length: 4.	
	gct buildChromosome.
	"-------"
	
	g := GAEngine new.
	g populationSize: 5.
	g numberOfGenes: chromosomeLength.
	
	indCache := Dictionary new.
	g createGeneBlock: [ :rand :index :ind | 
		(indCache includesKey: ind) ifFalse: [ gct buildChromosome. indCache at: ind put: gct chromosome. ].
		(indCache at: ind) atRandom: rand ].
	
	g fitnessBlock: [ :genes | 
			GCT new 
				chromosome: genes; 
				targetClass: gct targetClass; 
				measureCoverage ].
		
	g run.
	
	self halt.
	"TO INSPECT:"
	(GCT new chromosome: g logs first fittestIndividual genes) buildCodeWithAssertion.
	g logs collect: [ :l | l fittestIndividual fitness ].
	
]

{ #category : #running }
SmallEvoTest >> runTPoint [
	"
	self new runTPoint
	"
SmallEvoTest new
	targetClass: TPoint;
	generateTestNamed: #TPointTest;
	executionScenario: [ 
		| p |
		p := TPoint new x: 3; y: 10.
		p add: (TPoint new x: 1; y: 12) ];
	run
]

{ #category : #accessing }
SmallEvoTest >> targetClass: aClass [
	targetClass := aClass
]

{ #category : #running }
SmallEvoTest >> testClassUnderGeneration [

	(Smalltalk includesKey: generateTestNamed) ifFalse: [
		TestCase
			subclass: generateTestNamed
			instanceVariableNames: ''
			classVariableNames: ''
			package: 'GeneticallyCreatedTestsResults' ].
	^ Smalltalk at: generateTestNamed
]
