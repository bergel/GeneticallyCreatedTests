Class {
	#name : #MorphTestCase,
	#superclass : #TestCase,
	#instVars : [
		'morphCleaner'
	],
	#category : #'GeneticallyCreatedTests-Core-Evolution'
}

{ #category : #initialization }
MorphTestCase >> setUp [
	super setUp.
	morphCleaner := MorphCleaner new.
	morphCleaner setUp.
]

{ #category : #initialization }
MorphTestCase >> tearDown [
	morphCleaner tearDown
]
