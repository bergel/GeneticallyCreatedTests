Extension { #name : 'Behavior' }

{ #category : '*GeneticallyCreatedTests' }
Behavior >> methods [
	
	^ self methodDict values
]

{ #category : '*GeneticallyCreatedTests' }
Behavior >> testMethods [
	^ self methods select: [ :m | m selector beginsWith: 'test' ]
]
