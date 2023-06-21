Class {
	#name : #GCTAnalyzerPackage,
	#superclass : #S2Package,
	#category : #'GeneticallyCreatedTests-Profiling-TypeProfiler'
}

{ #category : #hooks }
GCTAnalyzerPackage class >> spyClassForClass [
	 ^ GCTAnalyzerClass
]
