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
SmallEvoTest >> chromosomeLength: anInteger [
	chromosomeLength := anInteger 
	
]

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

{ #category : #initialization }
SmallEvoTest >> populationSize [
	^ populationSize
]

{ #category : #initialization }
SmallEvoTest >> populationSize: nbOfIndividuals [
	populationSize := nbOfIndividuals
]

{ #category : #running }
SmallEvoTest >> removeTestClassUnderGenerationIfNecessary [

	(Smalltalk includesKey: generateTestNamed) ifTrue: [
		(Smalltalk at: generateTestNamed) removeFromSystemUnlogged ].

]

{ #category : #running }
SmallEvoTest >> run [
	| g indCache gct evolution cs mu |
	self assert: [ targetClass notNil ].
	
	self removeTestClassUnderGenerationIfNecessary.
	"-------"
	gct := GCT new.
	gct random: (Random seed: 42).
	gct targetClass: targetClass.
	
	gct spyRepository: (GCTAnalyzer profile: executionScenario onClasses: { targetClass }).
	gct length: chromosomeLength.	
	gct buildChromosome.
	"-------"
	
	g := GAEngine new.
	g endIfFitnessIsAbove: 1.0 orMax: 5.
	g populationSize: populationSize.
	g numberOfGenes: chromosomeLength.

	cs := GATestCreationCrossoverOperation new.
	mu := GAMutationFromCSOperation new crossOver: cs.
	mu newIndividualBlock: [ gct buildChromosome ].
	mu engine: g.
	g crossoverOperator: cs.
	g mutationOperator: mu.
	
	indCache := Dictionary new.

	g createGeneBlock: [ :rand :index :ind | 
		(indCache includesKey: ind) ifFalse: [ 
			gct buildChromosome. 
			indCache at: ind put: gct chromosome copy.
			 ].
		(indCache at: ind) at: index ].
	
	g fitnessBlock: [ :genes | 
			GCT new 
				chromosome: genes; 
				targetClass: gct targetClass; 
				measureCoverageOnClass: self testClassUnderGeneration ].
		
	g run.
	
	self halt.
		
	"INSTALL TEST RESULTS"
	g logs last population doWithIndex: [ :ind :index |
		gct := GCT new.
		gct chromosome: ind genes.
		self testClassUnderGeneration compile: (gct buildTestSuffix: index asString).
	].
	
	evolution := g logs collect: [ :l | l fittestIndividual fitness ].

	"TO INSPECT:"
	(GCT new chromosome: g logs last fittestIndividual genes) buildCodeWithAssertion.
	
	
]

{ #category : #examples }
SmallEvoTest >> runRSCanvas [
	"
	self new runRSCanvas
	"
SmallEvoTest new
	targetClass: RSCanvas;
	chromosomeLength: 15;
	populationSize: 15;
	generateTestNamed: #TRSCanvasTest;
	executionScenario: [ 
		| c |
		c := RSCanvas new.
		c add: RSBox new.
		c add: RSBox new.
		RSGridLayout on: c shapes.
		c open delete. ];
	run
]

{ #category : #examples }
SmallEvoTest >> runTPoint [
	"
	self new runTPoint
	"
SmallEvoTest new
	targetClass: TPoint;
	chromosomeLength: 8;
	populationSize: 10;
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
