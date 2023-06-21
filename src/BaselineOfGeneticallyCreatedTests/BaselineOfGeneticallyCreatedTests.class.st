Class {
	#name : #BaselineOfGeneticallyCreatedTests,
	#superclass : #BaselineOf,
	#category : #BaselineOfGeneticallyCreatedTests
}

{ #category : #accessing }
BaselineOfGeneticallyCreatedTests >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec package: 'Spy2-Core'.
			spec package: 'GeneticallyCreatedTests' ]
]
