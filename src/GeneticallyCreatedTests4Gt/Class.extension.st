Extension { #name : #Class }

{ #category : #'*GeneticallyCreatedTests4Gt' }
Class >> inspectTestGenerationResults: aView [
	<gtView>
	<gtClassView>
	| unnecessaryMessagesToReport |
	self isGenerated ifFalse: [ ^ aView empty ].
	unnecessaryMessagesToReport := #(#printString #assert:equals:).
	^ aView columnedList
		title: 'Diversity';
		priority: -20;
		items: self testMethods;
		column: '#'  
			text: [ :eachItem :eachIndex | 
				eachIndex asRopedText foreground: Color gray ]
			width: 30;
		column: 'Name' text: #selector width: 130;
		column: 'Nb msgs' text: [ :mthd | (mthd messages asSortedCollection copyWithoutAll: unnecessaryMessagesToReport) size ] width: 60;
		column: 'Messages' text: [ :mthd | '  ' join: (mthd messages asSortedCollection copyWithoutAll: unnecessaryMessagesToReport) ];
		yourself
]
