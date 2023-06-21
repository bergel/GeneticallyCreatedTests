Extension { #name : #Object }

{ #category : #'*Spy2-Core' }
Object >> instrumentRead: spySlot receiver: obj [
	[spySlot profiler readOn: spySlot receiver: obj withValue: self] spyProtected
]

{ #category : #'*Spy2-Core' }
Object >> instrumentWrite: spySlot receiver: obj withValue: aValue [
	[spySlot profiler writeOn: spySlot receiver: obj fromValue: aValue toValue: self] spyProtected
]

{ #category : #'*Spy2-Core' }
Object >> isSpy [

	^ false
]

{ #category : #'*Spy2-Core' }
Object >> isSpyMethod [

	^ false
]
