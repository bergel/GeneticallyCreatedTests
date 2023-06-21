Extension { #name : #TraitBehavior }

{ #category : #'*Spy2-Core' }
TraitBehavior >> createSpy: spy [
	^ spy profiler createSpyClass: self 
]

{ #category : #'*Spy2-Core' }
TraitBehavior >> getSpy: spy [
	^ spy profiler getSpyClass: self 
]
