Class {
	#name : #GCTMethodProxyLog,
	#superclass : #GCTMethodProxy,
	#category : 'GeneticallyCreatedTests-Profiling-Core'
}

{ #category : #evaluation }
GCTMethodProxyLog >> hookRun: aSelector with: anArray in: aReceiver [
	Transcript show: aReceiver class name; show: '>>'; show: aSelector; cr
]
