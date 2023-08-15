Class {
	#name : #GCTCoverageProfilerClass,
	#superclass : #S2Class,
	#category : #'GeneticallyCreatedTests-Profiling-CodeCoverage-OLD'
}

{ #category : #hooks }
GCTCoverageProfilerClass class >> spyClassForMethod [
	 ^ GCTCoverageProfilerMethod
]
