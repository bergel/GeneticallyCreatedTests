Extension { #name : #Collection }

{ #category : #'*Spy2-Core' }
Collection >> ensureDo: aBlock [ 
	self do: [ :element | 
		[ aBlock value: element ] valueUninterruptably ]
]
