Class {
	#name : #BaselineOfGeneticallyCreatedTests,
	#superclass : #BaselineOf,
	#category : #BaselineOfGeneticallyCreatedTests
}

{ #category : #accessing }
BaselineOfGeneticallyCreatedTests class >> loadLepiter [
	| currentProperties |
	currentProperties := LeDatabasesRegistry defaultLogicalDatabase properties.
	currentProperties
		addRegisteredDirectory: FileLocator imageDirectory / 'pharo-local' / 'iceberg' / 'bergel'
				/ 'GeneticallyCreatedTests' / 'lepiter'.
	LeDatabasesRegistry default defaultLogicalDatabase reload
]

{ #category : #baselines }
BaselineOfGeneticallyCreatedTests >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec package: 'Spy2-Core'.
			spec package: 'GeneticallyCreatedTests' ]
]
