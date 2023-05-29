Class {
	#name : #GATestCreationCrossoverOperation,
	#superclass : #GAAbstractCrossoverOperation,
	#category : #'GeneticallyCreatedTests-GeneticAlgorithm-Core'
}

{ #category : #'as yet unclassified' }
GATestCreationCrossoverOperation >> crossover: partnerA with: partnerB [
	"Return a new child, which is the result of mixing myself with the argument"
	| pointcut result |
	1 to: 5 do: [ :i |
		pointcut := self pickCutPointFor: partnerA.
		((partnerA genes at: pointcut) type == (partnerB genes at: pointcut) type) ifTrue: [ 
			result := self crossover: partnerA with: partnerB midpoint: pointcut.
			
			result adjustArguments.
			result resetObjectExample.
			^ result ]
	].
	self error: 'Cannot do an crossover'
]

{ #category : #'as yet unclassified' }
GATestCreationCrossoverOperation >> pickCutPointFor: partnerA [

	"Simply returns a random number between 1 and the number of genes of the individual provided as argument"

	^ (random nextInteger: partnerA numberOfGenes)
"	^ (random nextInteger: partnerA numberOfGenes - 2) + 1"
]
