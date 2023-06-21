Extension { #name : #RPackage }

{ #category : #'*Spy2-Core' }
RPackage >> addToSpyMetamodel: profiler [

	(profiler packages includes: self packageName)
		ifFalse: [ 
			profiler packagesDictionary 
				at: self packageName
				put: (profiler buildSpyPackage: self packageName) ].
	^ profiler packagesDictionary at: self packageName
]

{ #category : #'*Spy2-Core' }
RPackage >> asSpyRingDefinition [
	^ self asRingDefinition
]

{ #category : #'*Spy2-Core' }
RPackage >> createSpy: profiler [

	^ profiler createSpyPackage: self
]

{ #category : #'*Spy2-Core' }
RPackage >> getSpy: spy [

	^ spy profiler getSpyPackage: self
]
