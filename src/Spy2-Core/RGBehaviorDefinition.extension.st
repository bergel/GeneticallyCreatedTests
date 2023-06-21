Extension { #name : #RGBehaviorDefinition }

{ #category : #'*Spy2-Core' }
RGBehaviorDefinition >> getSpy: spy [
	^ self realClass getSpy: spy
]
