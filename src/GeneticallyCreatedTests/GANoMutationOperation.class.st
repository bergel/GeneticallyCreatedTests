Class {
	#name : #GANoMutationOperation,
	#superclass : #GAAbstractMutationOperation,
	#instVars : [
		'geneFactoryBlock'
	],
	#category : #'GeneticallyCreatedTests-GeneticAlgorithm-Core'
}

{ #category : #'as yet unclassified' }
GANoMutationOperation >> doMutate: individual [
	"Do not do mutation for now"
	^ individual
]
