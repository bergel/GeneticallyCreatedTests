Class {
	#name : #S2Gatherer,
	#superclass : #Object,
	#classVars : [
		'UniqueInstance'
	],
	#category : #'Spy2-Core-Instrumentator'
}

{ #category : #'as yet unclassified' }
S2Gatherer class >> uniqueInstance [
	^ UniqueInstance ifNil: [ UniqueInstance := self new ]
]

{ #category : #'as yet unclassified' }
S2Gatherer >> classForName: name [
	^ Smalltalk at: name
]

{ #category : #'as yet unclassified' }
S2Gatherer >> classesForClassCategories: categories [
	^ categories flatCollect: [ :each | self classesForClassCategory: categories ]
]

{ #category : #'as yet unclassified' }
S2Gatherer >> classesForClassCategory: category [
	^ (SystemOrganization listAtCategoryNamed: category) collect: [ :name | Smalltalk at: name ]
]

{ #category : #'as yet unclassified' }
S2Gatherer >> classesForNames: nameCollection [
	^ nameCollection collect: [ :n | self classForName: n ]
]

{ #category : #'as yet unclassified' }
S2Gatherer >> classesForPackage: package [
	^ self classesForPackages: { package }
]

{ #category : #'as yet unclassified' }
S2Gatherer >> classesForPackages: packageCollection [
	^ packageCollection flatCollect: #definedClasses
]

{ #category : #'as yet unclassified' }
S2Gatherer >> methodsForClass: class [
	^ self methodsForClasses: { class }
]

{ #category : #'as yet unclassified' }
S2Gatherer >> methodsForClasses: classCollection [
	| nonMetaclasses |
	nonMetaclasses := (classCollection collect: #instanceSide) asSet.
	^ (nonMetaclasses , (nonMetaclasses collect: #class)) flatCollect: #methods
]

{ #category : #'as yet unclassified' }
S2Gatherer >> methodsForPackage: package [
	^ self methodsForPackages: { package }
]

{ #category : #'as yet unclassified' }
S2Gatherer >> methodsForPackages: packageCollection [
	^ packageCollection flatCollect: #methods
]

{ #category : #'as yet unclassified' }
S2Gatherer >> packageForClass: aClass [
	^ aClass package
]

{ #category : #'as yet unclassified' }
S2Gatherer >> packageForName: name [
	^ RPackage organizer packageNamed: name
]

{ #category : #'as yet unclassified' }
S2Gatherer >> packagesForClasess: classes [
	^ (classes collect: #package) asSet asArray
]

{ #category : #'as yet unclassified' }
S2Gatherer >> packagesForRegex: regex [
	^ self packagesForRegexExpressions: { regex }
]

{ #category : #'as yet unclassified' }
S2Gatherer >> packagesForRegexExpressions: regexExpressions [
	^ (regexExpressions flatCollect: [ :regex | 
			RPackage organizer packages select: [:p | regex match: (p name asString)] ]) asSet
]
