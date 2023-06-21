Class {
	#name : #GCTCoverageProfiler,
	#superclass : #AnObsoleteS2Profiler,
	#category : #'GeneticallyCreatedTests-Profiling-CodeCoverage'
}

{ #category : #hooks }
GCTCoverageProfiler class >> spyClassForPackage [
	 ^ GCTCoverageProfilerPackage
]

{ #category : #coverage }
GCTCoverageProfiler >> coverage [
	| ms |
	ms := self allMethods.
	^ ((ms select: #isExecuted) size / ms size) asFloat
]
