Class {
	#name : #GCTCoverageProfilerPackage,
	#superclass : #S2Package,
	#category : #'GeneticallyCreatedTests-Profiling-CodeCoverage'
}

{ #category : #hooks }
GCTCoverageProfilerPackage class >> spyClassForClass [
	 ^ GCTCoverageProfilerClass
]
