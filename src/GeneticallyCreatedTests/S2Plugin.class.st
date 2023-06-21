Class {
	#name : #S2Plugin,
	#superclass : #Object,
	#instVars : [
		'profiler'
	],
	#category : #'GeneticallyCreatedTests-ProfilingFramework-Spy'
}

{ #category : #'instance creation' }
S2Plugin class >> on: aProfiler [

	^ self new profiler: aProfiler; yourself
]

{ #category : #testing }
S2Plugin >> isSpy [
	^ true
]

{ #category : #hooks }
S2Plugin >> priority [
	^ 10
]

{ #category : #accessing }
S2Plugin >> profiler [
	^ profiler
]

{ #category : #accessing }
S2Plugin >> profiler: anObject [
	profiler := anObject
]
