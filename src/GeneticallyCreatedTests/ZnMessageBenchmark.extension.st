Extension { #name : #ZnMessageBenchmark }

{ #category : #'*GeneticallyCreatedTests' }
ZnMessageBenchmark >> randomAsciiString: count random: random [
	^ String
		new: count
		streamContents: [ :stream |
			count timesRepeat: [ stream nextPut: ('0123456789ABCDEF' atRandom: random) ] ]
]

{ #category : #'*GeneticallyCreatedTests' }
ZnMessageBenchmark >> randomAsciiSymbol: count random: random [
	^ Symbol
		new: count
		streamContents: [ :stream |
			stream nextPut: ('ABCDEF' atRandom: random).
			(count-1) timesRepeat: [ stream nextPut: ('0123456789ABCDEF' atRandom: random) ] ]
]
