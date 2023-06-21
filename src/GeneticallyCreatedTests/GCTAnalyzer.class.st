Class {
	#name : #GCTAnalyzer,
	#superclass : #AnObsoleteS2Profiler,
	#category : #'GeneticallyCreatedTests-Profiling-TypeProfiler'
}

{ #category : #hooks }
GCTAnalyzer class >> spyClassForPackage [
	 ^ GCTAnalyzerPackage
]
