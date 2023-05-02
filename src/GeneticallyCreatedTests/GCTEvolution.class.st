Class {
	#name : #GCTEvolution,
	#superclass : #Object,
	#category : #'GeneticallyCreatedTests-Core-Evolution'
}

{ #category : #running }
GCTEvolution >> run [
	"
	self new run
	"
	| g chromosomeLength indCache gct |
	chromosomeLength := 4.
	
	"-------"
	gct := GCT new.
	gct random: (Random seed: 42).
	gct targetClass: MyPoint.
	
	gct spyRepository: (GCTAnalyzer profile: [ 
		| p |
		p := MyPoint new x: 3; y: 10.
		p add: (MyPoint new x: 1; y: 12) ] onClasses: { MyPoint }).

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
