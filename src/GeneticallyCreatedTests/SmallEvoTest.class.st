"
The class `SmallEvoTest` is the entry point of the framework to generate tests. 
Here is an example on how to use it:
```
SmallEvoTest new
		targetClass: GCPoint;
		generateTestNamed: #GCPointTest;
		numberOfTestsToBeCreated: 10;
		nbOfStatements: 5;
		executionScenario: [ | p |
			p := GCPoint new
					x: 3;
					y: 10.
			p
				add: (GCPoint new
						x: 1;
						y: 12) ];
		run.
```

"
Class {
	#name : #SmallEvoTest,
	#superclass : #Object,
	#instVars : [
		'chromosomeLength',
		'populationSize',
		'targetClass',
		'executionScenario',
		'generateTestNamed',
		'methodNameBlackList',
		'methodNameToExclude',
		'maxNumberOfGenerations',
		'testSuperclass',
		'objectBuilders'
	],
	#category : #'GeneticallyCreatedTests-Core-Evolution'
}

{ #category : #accessing }
SmallEvoTest >> chromosomeLength: anInteger [
	chromosomeLength := anInteger 
	
]

{ #category : #accessing }
SmallEvoTest >> excludeMethodName: aSelector [
	methodNameToExclude add: aSelector
]

{ #category : #accessing }
SmallEvoTest >> executionScenario: aBlock [
	executionScenario := aBlock 
]

{ #category : #accessing }
SmallEvoTest >> executionScenarioFromTestsInPackage: aPackageName [

	self executionScenario: [ 
		((RPackageOrganizer default packageNamed: aPackageName) definedClasses select: [ :cls | cls subclasses isEmpty and: [ cls inheritsFrom: TestCase ] ]) do: [ :cls | cls  buildSuite run ]
 ]
]

{ #category : #accessing }
SmallEvoTest >> forType: aBehavior buildObject: oneArgBlock [
	objectBuilders add: aBehavior -> oneArgBlock
]

{ #category : #accessing }
SmallEvoTest >> generateTestNamed: aSymbol [
	"Set the name of the unit test to be generated"
	generateTestNamed := aSymbol
]

{ #category : #accessing }
SmallEvoTest >> gtMethodsFor: aView [
	<gtView>
	(Smalltalk globals includesKey: generateTestNamed) ifFalse: [ ^ aView empty ].
	^ aView forward
		title: 'Test methods';
		priority: 10;
		object: generateTestNamed asClass;
		view: #gtTestsFor:
]

{ #category : #initialization }
SmallEvoTest >> initialize [
	super initialize.
	chromosomeLength := 4.
	populationSize := 5.
	targetClass := nil. "Need to be manually set!"
	executionScenario := [  ].
	methodNameToExclude := OrderedCollection new.
	self maxNumberOfGenerations: 5.
	
	"Set the default superclass for the test"
	testSuperclass := TestCase.
	
	objectBuilders := OrderedCollection new.
]

{ #category : #accessing }
SmallEvoTest >> maxNumberOfGenerations: anInteger [

	maxNumberOfGenerations := anInteger
]

{ #category : #accessing }
SmallEvoTest >> nbOfStatements: anInteger [
	self chromosomeLength: anInteger
]

{ #category : #accessing }
SmallEvoTest >> numberOfTestsToBeCreated: anInteger [
	self populationSize: anInteger
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
	| g indCache gct evolution cs mu morphCleaner profilingRepo initialMarkedMethods newProf |
	self assert: [ targetClass notNil ].
	
	morphCleaner := MorphCleaner new.
	morphCleaner setUp.
	self removeTestClassUnderGenerationIfNecessary.
	"-------"
	profilingRepo := GCTMethodProxyInstallerType new targetClass: targetClass; run: executionScenario.
	gct := GCT new.
	gct random: (Random seed: 42).
	gct targetClass: targetClass.
	gct methodNameToExclude: methodNameToExclude asArray.
	
	objectBuilders do: [ :assoc |
		gct forType: assoc key buildObject: assoc value ].
	
	"gct spyRepository: (GCTAnalyzer profile: executionScenario onClasses: { targetClass })."
	gct spyRepository: profilingRepo.
	gct length: chromosomeLength.	
	gct buildChromosome.
	initialMarkedMethods := profilingRepo allMarkedMethods.
	"-------"
	
	g := GAEngine new.
	g endIfFitnessIsAbove: 1.0 orMax: maxNumberOfGenerations.
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
		
	[ g run ] ensure: [ morphCleaner tearDown ].
	
	"INSTALL TEST RESULTS"
	g logs last population doWithIndex: [ :ind :index |
		| gct2 |
		ind resetObjectExample.
		gct2 := GCT new.
		gct2 chromosome: ind genes.
		gct2 random: gct random.
		self testClassUnderGeneration compile: (gct2 buildTestSuffix: index asString).
	].

	"GET THE COVERED METHODS"
	newProf := GCTMethodProxyInstallerType new 
					targetClass: targetClass; 
					run: [ self testClassUnderGeneration buildSuite run ].
	newProf allMarkedMethods.
	

	"WRITE THE EVOLUTIONARY METADATA"
	evolution := g logs collect: [ :l | l fittestIndividual fitness ].
	self testClassUnderGeneration compile: 
		'evolution', String cr, 
			' "Initial marked methods: ', initialMarkedMethods printString, '"', String cr,
			'	^ ', evolution asArray printString.

	"CLEANING THE SPACE, IF NECESSARY"
	morphCleaner tearDown 
]

{ #category : #examples }
SmallEvoTest >> runGCPoint [
	"
	self new runGCPoint
	"
SmallEvoTest new
	targetClass: GCPoint;
	chromosomeLength: 5;
	populationSize: 5;
	generateTestNamed: #GCPointTest;
	executionScenario: [ 
		| p |
		p := GCPoint new x: 3 y: 10.
		p add: (GCPoint new x: 1 y: 12) ];
	run
]

{ #category : #examples }
SmallEvoTest >> runGeometry [
	"
	self new runGeometry
	"
"

G1DElement allSubclasses do: [ :class | 
	SmallEvoTest new
		targetClass: class;
		chromosomeLength: 15;
		populationSize: 25;
		maxNumberOfGenerations: 7;
		excludeMethodName: #currentTime;
		generateTestNamed: ('GCT', class name, 'Test') asSymbol;
		executionScenarioFromTestsInPackage: 'Geometry-Tests';
		run ]
"
]

{ #category : #examples }
SmallEvoTest >> runGeometryGSegment [
	"
	self new runGeometryGSegment
	"
"
	
	SmallEvoTest new
		targetClass: GSegment;
		chromosomeLength: 15;
		populationSize: 25;
		maxNumberOfGenerations: 7;
		excludeMethodName: #currentTime;
		generateTestNamed: ('GCT', 'GSegment', 'Test') asSymbol;
		executionScenarioFromTestsInPackage: 'Geometry-Tests';
		run
"
]

{ #category : #examples }
SmallEvoTest >> runManyClasses [
	"
	self new runManyClasses
	"
"

{ RSBox . RSGridLayout . RSCanvas . RSGroup } do: [ :class | 
	SmallEvoTest new
		targetClass: class;
		chromosomeLength: 15;
		populationSize: 25;
		maxNumberOfGenerations: 7;
		excludeMethodName: #currentTime;
		generateTestNamed: ('GCT', class name, 'Test') asSymbol;
		executionScenario: [ 
			| c |
			c := RSCanvas new.
			c add: RSBox new.
			c add: RSBox new.
			RSGridLayout on: c shapes.
			c open delete. ];
	run ]
"
]

{ #category : #examples }
SmallEvoTest >> runRSCanvas [
	"
	self new runRSCanvas
	"
"SmallEvoTest new
	targetClass: RSCanvas;
	chromosomeLength: 15;
	populationSize: 25;
	excludeMethodName: #currentTime;
	generateTestNamed: #TRSCanvasTest;
	testSuperclass: MorphTestCase;
	executionScenario: [ 
		| c |
		c := RSCanvas new.
		c add: RSBox new.
		c add: RSBox new.
		RSGridLayout on: c shapes.
		c open delete. ];
	run"
]

{ #category : #examples }
SmallEvoTest >> tPointExample [

	"
	self new tPointExample
	"

	<gtExample>
	<noTest>
	SmallEvoTest new
		targetClass: GCPoint;
		chromosomeLength: 8;
		populationSize: 10;
		generateTestNamed: #GCPointTest;
		executionScenario: [ 
			| p |
			p := GCPoint new x: 3 y: 10.
			p add: (GCPoint new x: 1 y: 12) ];
		run.
	^ #GCPointTest asClass
]

{ #category : #accessing }
SmallEvoTest >> targetClass: aClass [
	targetClass := aClass
]

{ #category : #running }
SmallEvoTest >> testClassUnderGeneration [
	| cls |
	(Smalltalk includesKey: generateTestNamed) ifFalse: [
		testSuperclass
			subclass: generateTestNamed
			instanceVariableNames: ''
			classVariableNames: ''
			package: 'GeneticallyCreatedTestsResults' ].
	cls := Smalltalk at: generateTestNamed.
	cls class compile: 'isGenerated
	^ true '.
	^ cls
]

{ #category : #accessing }
SmallEvoTest >> testSuperclass: aSuperclass [
	"Set the base test class that a subclass will be created from. The default is TestCase, but could be other"
	testSuperclass := aSuperclass
]
