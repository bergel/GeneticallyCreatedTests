Class {
	#name : #GCTAnalyzer,
	#superclass : #S2Profiler,
	#category : #'GeneticallyCreatedTests-Profiling-TypeProfiler'
}

{ #category : #hooks }
GCTAnalyzer class >> spyClassForPackage [
	 ^ GCTAnalyzerPackage
]
