Extension { #name : #Collection }

{ #category : #'*GeneticallyCreatedTests' }
Collection >> ensureDo: aBlock [ 
	self do: [ :element | 
		[ aBlock value: element ] valueUninterruptably ]
]
