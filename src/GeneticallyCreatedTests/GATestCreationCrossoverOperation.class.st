Class {
	#name : #GATestCreationCrossoverOperation,
	#superclass : #GAAbstractCrossoverOperation,
	#category : #'GeneticallyCreatedTests-GeneticAlgorithm-Core'
}

{ #category : #'as yet unclassified' }
GATestCreationCrossoverOperation >> crossover: partnerA with: partnerB [
	"Return a new child, which is the result of mixing myself with the argument"
	| pointcut result wasFound |
	1 to: 20 do: [ :i |
		pointcut := self pickCutPointFor: partnerA.
		 
		result := self crossover: partnerA with: partnerB midpoint: pointcut.
		wasFound := nil.
		[ wasFound := result adjustArguments ] on: Exception do: [ :ex | ].
		wasFound ifNotNil: [
			"result resetObjectExample."
			^ result ]
	].
	"self error: 'Cannot do an crossover'."
	^ partnerA
]

{ #category : #'as yet unclassified' }
GATestCreationCrossoverOperation >> pickCutPointFor: partnerA [

	"Simply returns a random number between 1 and the number of genes of the individual provided as argument"

	^ (random nextInteger: partnerA numberOfGenes)
"	^ (random nextInteger: partnerA numberOfGenes - 2) + 1"
]
