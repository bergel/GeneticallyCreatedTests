Class {
	#name : #MorphCleaner,
	#superclass : #Object,
	#instVars : [
		'allMorphs'
	],
	#category : #'GeneticallyCreatedTests-Core-Evolution'
}

{ #category : #initialization }
MorphCleaner >> setUp [
	allMorphs := World submorphs
]

{ #category : #initialization }
MorphCleaner >> tearDown [
	(World submorphs copyWithoutAll: allMorphs) do: #delete
]
