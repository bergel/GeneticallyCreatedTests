Class {
	#name : #GCTCoverageProfilerMethod,
	#superclass : #AnObsoleteS2Method,
	#instVars : [
		'isExecuted'
	],
	#category : #'GeneticallyCreatedTests-Profiling-CodeCoverage'
}

{ #category : #hooks }
GCTCoverageProfilerMethod >> beforeRun: methodName with: listOfArguments in: receiver [
	"This method is executed before each method of the profiled application.
	 Insert here the instrumentation you would like to perform during the profiling."
	isExecuted := true
]

{ #category : #initialization }
GCTCoverageProfilerMethod >> initialize [
	super initialize.
	isExecuted := false
]

{ #category : #accessing }
GCTCoverageProfilerMethod >> isExecuted [
	^ isExecuted
]
