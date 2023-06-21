Extension { #name : #GtHome }

{ #category : #'*GeneticallyCreatedTests4Gt' }
GtHome >> geneticTestsHomeSection [
	<gtHomeSection>
	^ GtHomeStartPageSection new 
		title: 'Genetically Created Tests';
		description: 'Genetically Created Tests project';
		databaseName: 'bergel/GeneticallyCreatedTests/lepiter';
		startPageName: 'Genetically Created Tests';
		priority: 8
]
