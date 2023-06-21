Extension { #name : #BlockClosure }

{ #category : #'*Spy2-Core' }
BlockClosure >> spyHandleUnwind [
	self on: Exception do: [ :ex |
		Spy2 isDebugSpyEnabled 
			ifTrue: [ 
				Spy2 disableDebugSpy.
				ex pass ]
			ifFalse: [ 
				ex return: nil ] ].
]

{ #category : #'*Spy2-Core' }
BlockClosure >> spyProtected [
	[ self spyRecursionProtectedBlock ] spyHandleUnwind
]

{ #category : #'*Spy2-Core' }
BlockClosure >> spyRecursionProtectedBlock [
	S2Lock isLocked ifTrue: [ ^ nil ].
	[	S2Lock lock.
		self value. 
	] ensure: [ S2Lock unlock ]
]
