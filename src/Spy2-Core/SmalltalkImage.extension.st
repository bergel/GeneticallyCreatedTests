Extension { #name : #SmalltalkImage }

{ #category : #'*Spy2-Core' }
SmalltalkImage >> allMethods [
	^ self allClasses flatCollect: [ :cls | cls methods , cls class methods ]
]
