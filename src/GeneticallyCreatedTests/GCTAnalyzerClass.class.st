Class {
	#name : #GCTAnalyzerClass,
	#superclass : #S2Class,
	#category : #'GeneticallyCreatedTests-TypeProfiler'
}

{ #category : #hooks }
GCTAnalyzerClass class >> spyClassForMethod [
	 ^ GCTAnalyzerMethod
]
