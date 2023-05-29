Class {
	#name : #GAMutationFromCSOperation,
	#superclass : #GAAbstractMutationOperation,
	#instVars : [
		'newIndividualBlock',
		'crossOver',
		'engine'
	],
	#category : #'GeneticallyCreatedTests-GeneticAlgorithm-Core'
}

{ #category : #'as yet unclassified' }
GAMutationFromCSOperation >> crossOver: obj [
	crossOver := obj
]

{ #category : #'as yet unclassified' }
GAMutationFromCSOperation >> doMutate: individual [
	^ crossOver crossover: individual with: engine buildNewIndividual "newIndividualBlock value"
]

{ #category : #accessing }
GAMutationFromCSOperation >> engine: anGAEngine [
	engine := anGAEngine 
	
]

{ #category : #accessing }
GAMutationFromCSOperation >> newIndividualBlock: aBlock [
	newIndividualBlock := aBlock
]
