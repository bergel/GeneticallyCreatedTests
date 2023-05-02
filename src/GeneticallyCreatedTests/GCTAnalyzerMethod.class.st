Class {
	#name : #GCTAnalyzerMethod,
	#superclass : #S2Method,
	#instVars : [
		'signature'
	],
	#category : #'GeneticallyCreatedTests-TypeProfiler'
}

{ #category : #hooks }
GCTAnalyzerMethod >> beforeRun: methodName with: listOfArguments in: receiver [
	"This method is executed before each method of the profiled application.
	 Insert here the instrumentation you would like to perform during the profiling."
	| argTypes |
	argTypes := listOfArguments collect: [ :o | o class name ].
	signature ifNil: [ signature := { self classSpy className . methodName . argTypes . nil } ]
]

{ #category : #hooks }
GCTAnalyzerMethod >> signature [
	^ signature
]
