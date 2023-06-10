Extension { #name : #ZnMessageBenchmark }

{ #category : #'*GeneticallyCreatedTests' }
ZnMessageBenchmark >> randomAsciiString: count random: random [
	^ String
		new: count
		streamContents: [ :stream |
			count timesRepeat: [ stream nextPut: ('0123456789ABCDEF' atRandom: random) ] ]
]
