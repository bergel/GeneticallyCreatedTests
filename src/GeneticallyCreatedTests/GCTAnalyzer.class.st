Class {
	#name : #GCTAnalyzer,
	#superclass : #S2Profiler,
	#category : #'GeneticallyCreatedTests-TypeProfiler'
}

{ #category : #hooks }
GCTAnalyzer class >> spyClassForPackage [
	 ^ GCTAnalyzerPackage
]
