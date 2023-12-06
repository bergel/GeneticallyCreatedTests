Class {
	#name : 'MorphTestCase',
	#superclass : 'TestCase',
	#instVars : [
		'morphCleaner'
	],
	#category : 'GeneticallyCreatedTests-MorphicUtility',
	#package : 'GeneticallyCreatedTests',
	#tag : 'MorphicUtility'
}

{ #category : 'initialization' }
MorphTestCase >> setUp [
	super setUp.
	morphCleaner := MorphCleaner new.
	morphCleaner setUp.
]

{ #category : 'initialization' }
MorphTestCase >> tearDown [
	morphCleaner tearDown
]
