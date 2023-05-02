Class {
	#name : #GCTCoverageProfilerClass,
	#superclass : #S2Class,
	#category : #'GeneticallyCreatedTests-Profiling-CodeCoverage'
}

{ #category : #hooks }
GCTCoverageProfilerClass class >> spyClassForMethod [
	 ^ GCTCoverageProfilerMethod
]
