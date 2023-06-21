Extension { #name : #Pragma }

{ #category : #'*Spy2-Core' }
Pragma class >> withPragmasIn: aClass do: aBlock [
	aClass selectorsAndMethodsDo: [ :selector :method | 
		method isSpy ifTrue: [ method originalMethod pragmas do: aBlock ] ifFalse: [ method pragmas do: aBlock ]  ]
]
