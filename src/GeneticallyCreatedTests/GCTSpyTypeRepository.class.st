Class {
	#name : #GCTSpyTypeRepository,
	#superclass : #GCTTypeRepository,
	#instVars : [
		'profiler'
	],
	#category : #'GeneticallyCreatedTests-Core-CodeGeneration'
}

{ #category : #'as yet unclassified' }
GCTSpyTypeRepository >> classNamed: className method: selector [
	^ (self profiler >> className >> selector) signature
]

{ #category : #'as yet unclassified' }
GCTSpyTypeRepository >> classNamed: className method: selector argumentsTypes: argumentsType returnType: returnType [
	self error: 'Should not be invoked'
]

{ #category : #accessing }
GCTSpyTypeRepository >> profiler [
	^ profiler
]

{ #category : #accessing }
GCTSpyTypeRepository >> profiler: aSpyProfiler [
	self assert: [ aSpyProfiler class == GCTAnalyzer ].
	profiler := aSpyProfiler
]
