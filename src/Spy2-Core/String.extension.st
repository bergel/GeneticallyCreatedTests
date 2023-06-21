Extension { #name : #String }

{ #category : #'*Spy2-Core' }
String >> asGlobal [
	^ Smalltalk bindingOf: self
]
