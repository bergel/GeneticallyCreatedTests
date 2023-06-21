Extension { #name : #Class }

{ #category : #'*Spy2-Core' }
Class >> addToSpyMetamodel: profiler [

	^ profiler addClassToSpyMetamodel: self
]

{ #category : #'*Spy2-Core' }
Class >> allSuperclassesInPackage [

	^ self allSuperclasses select: [ :cls | cls package = self package ]
]

{ #category : #'*Spy2-Core' }
Class >> asGlobal [
	^ self name asGlobal
]

{ #category : #'*Spy2-Core' }
Class >> createSpy: spy [

	^ spy profiler createSpyClass: self
]

{ #category : #'*Spy2-Core' }
Class >> getSpy: spy [

	^ spy profiler getSpyClass: self
]

{ #category : #'*Spy2-Core' }
Class >> withAllSuperclassesInPackage [
	^ { self } , self allSuperclassesInPackage
]
