Class {
	#name : #GCTMethodProxyCoverage,
	#superclass : #GCTMethodProxy,
	#instVars : [
		'isMarked'
	],
	#category : #'GeneticallyCreatedTests-Profiling-Core'
}

{ #category : #evaluation }
GCTMethodProxyCoverage >> hookRun: aSelector with: anArray in: aReceiver [
	isMarked := true
]

{ #category : #initialization }
GCTMethodProxyCoverage >> initialize [
	super initialize.
	isMarked := false
]

{ #category : #initialization }
GCTMethodProxyCoverage >> isMarked [
	^ isMarked
]
