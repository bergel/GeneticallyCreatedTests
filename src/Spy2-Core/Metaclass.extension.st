Extension { #name : #Metaclass }

{ #category : #'*Spy2-Core' }
Metaclass >> addToSpyMetamodel: profiler [

	^ profiler addMetaclassToSpyMetamodel: self
]

{ #category : #'*Spy2-Core' }
Metaclass >> createSpy: spy [

	^ spy profiler createSpyMetaclass: self
]

{ #category : #'*Spy2-Core' }
Metaclass >> getSpy: spy [

	^ spy profiler getSpyMetaclass: self
]
