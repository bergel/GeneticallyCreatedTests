Class {
	#name : #GCTCoverageProfiler,
	#superclass : #S2Profiler,
	#category : #'GeneticallyCreatedTests-Profiling-CodeCoverage-OLD'
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
