Class {
	#name : #GCTAnalyzerClass,
	#superclass : #S2Class,
	#category : #'GeneticallyCreatedTests-Profiling-TypeProfiler'
}

{ #category : #hooks }
GCTAnalyzerClass class >> spyClassForMethod [
	 ^ GCTAnalyzerMethod
]
