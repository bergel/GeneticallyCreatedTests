Class {
	#name : #GCTCoverageProfilerClass,
	#superclass : #AnObsoleteS2Class,
	#category : #'GeneticallyCreatedTests-Profiling-CodeCoverage'
}

{ #category : #hooks }
GCTCoverageProfilerClass class >> spyClassForMethod [
	 ^ GCTCoverageProfilerMethod
]
