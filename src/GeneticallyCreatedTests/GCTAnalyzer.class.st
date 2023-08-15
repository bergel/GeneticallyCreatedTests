Class {
	#name : #GCTAnalyzer,
	#superclass : #S2Profiler,
	#category : #'GeneticallyCreatedTests-Profiling-TypeProfiler-OLD'
}

{ #category : #hooks }
GCTAnalyzer class >> spyClassForPackage [
	 ^ GCTAnalyzerPackage
]
