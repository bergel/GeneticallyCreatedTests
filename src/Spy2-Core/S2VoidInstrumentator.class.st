Class {
	#name : #S2VoidInstrumentator,
	#superclass : #S2AbstractInstrumentator,
	#category : #'Spy2-Core-Instrumentator'
}

{ #category : #hook }
S2VoidInstrumentator >> applyOnAction: aProfiler [
	self assert: [ aProfiler instrumentator isVoidInstrumentator not ] description: 'Not to be used over another VoidInstrumentator. Ensure that profiler has started.'.
	[ self profiler afterProfiling ]
		ensure: [ 
			super applyOnAction: aProfiler.
			self uninstallProfilerPlugins.
			self profiler afterUninstalling]
]

{ #category : #accessing }
S2VoidInstrumentator >> classes [
	^ #()
]

{ #category : #testing }
S2VoidInstrumentator >> isVoidInstrumentator [
	^true
]

{ #category : #accessing }
S2VoidInstrumentator >> methods [
	^ #()
]

{ #category : #accessing }
S2VoidInstrumentator >> packages [ 
	^ #()
]
