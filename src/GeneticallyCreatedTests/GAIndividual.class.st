Class {
	#name : 'GAIndividual',
	#superclass : 'GAObject',
	#instVars : [
		'genes',
		'fitness'
	],
	#category : 'GeneticallyCreatedTests-GeneticAlgorithm-Core',
	#package : 'GeneticallyCreatedTests',
	#tag : 'GeneticAlgorithm-Core'
}

{ #category : 'as yet unclassified' }
GAIndividual class >> create: numberOfIndividuals individualsAndInitialize: numberOfGenes genesWith: geneBlockFactory [
 	"Factory method to easily create a number of Individuals.
        numberOfIndividuals : is the number of individuals to return
        numberOfGenes : number of genes each individual should have
        geneBlockFactory : is a one-argument block to generate a gene. It takes a random generator as argument"
	^ self create: numberOfIndividuals individualsAndInitialize: numberOfGenes genesWith: geneBlockFactory using: (Random new seed: 42)
]

{ #category : 'as yet unclassified' }
GAIndividual class >> create: numberOfIndividuals individualsAndInitialize: numberOfGenes genesWith: geneBlockFactory using: randomNumberGeneration [
	"Factory method to easily create a population of Individuals.
		numberOfIndividuals : is the number of individuals to return
		numberOfGenes : number of genes each individual should have
		geneBlockFactory : is a one-argument block to generate a gene. It takes a random generator as argument
		randomNumberGeneration : is a random generator"
	| someIndividuals ind |
	someIndividuals := OrderedCollection new.
	numberOfIndividuals timesRepeat: [ 
		ind := self new.
		ind random: randomNumberGeneration.
		ind set: numberOfGenes genesUsing: geneBlockFactory.
		someIndividuals add: ind ].
	^ someIndividuals
]

{ #category : 'initialization' }
GAIndividual >> adjustArguments [
	^ GCT new chromosome: genes; random: random; adjustArguments.

]

{ #category : 'as yet unclassified' }
GAIndividual >> computeFitnessUsing: fitnessBlock [
	"Compute the fitness of myself if not already computed"
	self assert: [ genes notNil ] description: 'Need to have some genes first'.

	"Simply exit if already computed"
	fitness ifNotNil: [ ^ self ].

	"Compute the fitness score"
	fitness := fitnessBlock value: genes
]

{ #category : 'as yet unclassified' }
GAIndividual >> fitness [
	"Return the fitness value of the individual"
	^ fitness 
]

{ #category : 'as yet unclassified' }
GAIndividual >> genes [
	"Return the individual's genes"
	^ genes
]

{ #category : 'as yet unclassified' }
GAIndividual >> genes: someGenes [
	"Set the genes of the individual. Used by the genetic operations."
	genes := someGenes
]

{ #category : 'as yet unclassified' }
GAIndividual >> numberOfGenes [
	"Return the number of genes the individual has"
	^ self genes size
]

{ #category : 'initialization' }
GAIndividual >> resetObjectExample [
	GCT new chromosome: genes; resetObjectExample.

]

{ #category : 'as yet unclassified' }
GAIndividual >> set: numberOfGenes genesUsing: geneBlockFactory [
	"Public method - Generate the genes of the individual"

	self checkForRandomNumber.
	genes := (1 to: numberOfGenes)
		collect: [ :index | geneBlockFactory cull: random cull: index cull: self ]
]
