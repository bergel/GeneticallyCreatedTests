Class {
	#name : 'GCTProvidedTypeRepository',
	#superclass : 'GCTTypeRepository',
	#instVars : [
		'types'
	],
	#category : 'GeneticallyCreatedTests-Core-CodeGeneration',
	#package : 'GeneticallyCreatedTests',
	#tag : 'Core-CodeGeneration'
}

{ #category : 'as yet unclassified' }
GCTProvidedTypeRepository >> classNamed: className method: selector [
	self assert: [ className isSymbol ].
	self assert: [ selector isSymbol ].
	^ types detect: [ :tup | (tup first: 2) = { className . selector } ]
]

{ #category : 'as yet unclassified' }
GCTProvidedTypeRepository >> classNamed: className method: selector argumentsTypes: argumentsType returnType: returnType [
	self assert: [ className isSymbol ].
	self assert: [ selector isSymbol ].
	self assert: [ argumentsType allSatisfy: #isSymbol ].
	self assert: [ returnType isSymbol ].
	types add: { className . selector . argumentsType . returnType }
]

{ #category : 'as yet unclassified' }
GCTProvidedTypeRepository >> initialize [
	super initialize.
	types := OrderedCollection new
]

{ #category : 'as yet unclassified' }
GCTProvidedTypeRepository >> types [
	^ types
]
