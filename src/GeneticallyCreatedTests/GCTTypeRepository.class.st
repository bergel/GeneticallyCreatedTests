Class {
	#name : #GCTTypeRepository,
	#superclass : #Object,
	#category : 'GeneticallyCreatedTests-Core-CodeGeneration'
}

{ #category : #'as yet unclassified' }
GCTTypeRepository >> classNamed: className method: selector [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
GCTTypeRepository >> classNamed: className method: selector argumentsTypes: argumentsType returnType: returnType [
	self subclassResponsibility
]
