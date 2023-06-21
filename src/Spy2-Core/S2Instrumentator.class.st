Class {
	#name : #S2Instrumentator,
	#superclass : #S2AbstractInstrumentator,
	#instVars : [
		'classes',
		'methods',
		'packages'
	],
	#category : #'Spy2-Core-Instrumentator'
}

{ #category : #'generic api' }
S2Instrumentator class >> onClass: class [
	^ self new onClass: class
]

{ #category : #'generic api' }
S2Instrumentator class >> onClassCategories: categories [
	^ self new onClassCategories: categories
]

{ #category : #'generic api' }
S2Instrumentator class >> onClassCategory: object [
	^ self new onClassCategory: object
]

{ #category : #'generic api' }
S2Instrumentator class >> onClassNamed: className [
	^ self new onClassNamed: className
]

{ #category : #'generic api' }
S2Instrumentator class >> onClasses: classCollection [
	^ self new onClasses: classCollection
]

{ #category : #'generic api' }
S2Instrumentator class >> onClassesNamed: classNames [
	^ self new onClassesNamed: classNames
]

{ #category : #'generic api' }
S2Instrumentator class >> onMethod: method [
	^ self new onMethod: method
]

{ #category : #'generic api' }
S2Instrumentator class >> onMethods: aMethodCollection [
	^ self new onMethods: aMethodCollection
]

{ #category : #'generic api' }
S2Instrumentator class >> onPackage: package [
	^ self new onPackage: package
]

{ #category : #'generic api' }
S2Instrumentator class >> onPackageNamed: packageName [
	^ self new onPackageNamed: packageName 
]

{ #category : #'generic api' }
S2Instrumentator class >> onPackages: pacakgeCollection [
	^ self new onPackages: pacakgeCollection
]

{ #category : #'generic api' }
S2Instrumentator class >> onPackagesMatching: regex [
	^ self new onPackagesMatching: regex
]

{ #category : #'generic api' }
S2Instrumentator class >> onPackagesMatchingExpressions: expressions [
	^ self new onPackagesMatchingExpressions: expressions
]

{ #category : #'generic api' }
S2Instrumentator class >> onPackagesNamed: names [
	^ self new onPackagesNamed: names
]

{ #category : #accessing }
S2Instrumentator >> classes [
	^ classes copy
]

{ #category : #accessing }
S2Instrumentator >> methods [
	^ methods copy
]

{ #category : #'specific api' }
S2Instrumentator >> methods: methodCollection classes: classCollection [
	self methods: methodCollection classes: classCollection packages: #()
]

{ #category : #'specific api' }
S2Instrumentator >> methods: methodCollection classes: classCollection packages: pacakgeCollection [
	self assert: [ methods isNil and: [ classes isNil and: [ packages isNil]] ] 
		description: 'These are final variables, should not change to prevent erratic behavior.'.
	methods := self rejectBlacklistFromMethods: (methodCollection 
						collect: #asSpyRingDefinition) asSet.
	classes := ((self rejectTraitsFromClasses: classCollection)
						collect: #instanceSide) asSet collect: #asSpyRingDefinition.
	packages := pacakgeCollection asSet collect: #asSpyRingDefinition.
]

{ #category : #'generic api' }
S2Instrumentator >> onClass: class [
	self 
		methods: (self gather methodsForClass: class)
		classes: { class }
]

{ #category : #'generic api' }
S2Instrumentator >> onClassCategories: categories [
	|classCollection|
	classCollection := self gather classesForClassCategories: categories.
	self 
		methods: (self gather methodsForClasses: classCollection)
		classes: classCollection
]

{ #category : #'generic api' }
S2Instrumentator >> onClassCategory: category [
	|classCollection|
	classCollection := self gather classesForClassCategory: category.
	self 
		methods: (self gather methodsForClasses: classCollection)
		classes: classCollection
]

{ #category : #'generic api' }
S2Instrumentator >> onClassNamed: className [
	| class |
	class := Smalltalk at: className.
	self
		methods: (self gather methodsForClass: class)
		classes: { class }
]

{ #category : #'generic api' }
S2Instrumentator >> onClasses: classCollection [
	self
		methods: (self gather methodsForClasses: classCollection)
		classes: classCollection copy
]

{ #category : #'generic api' }
S2Instrumentator >> onClassesNamed: classNames [
	| classCollection |
	classCollection := classNames collect: [ :name | Smalltalk at: name ].
	self
		methods: (self gather methodsForClasses: classCollection)
		classes: classCollection
]

{ #category : #'generic api' }
S2Instrumentator >> onMethod: method [
	self
		methods: { method }
		classes: #()
]

{ #category : #'generic api' }
S2Instrumentator >> onMethods: aMethodCollection [
	self
		methods: aMethodCollection copy
		classes: #()
]

{ #category : #'generic api' }
S2Instrumentator >> onPackage: package [
	self 
		methods: (self gather methodsForPackage: package)
		classes: (self gather classesForPackage: package)
		packages: { package }
]

{ #category : #'generic api' }
S2Instrumentator >> onPackageNamed: packageName [ 
	| package |
	package := RPackage organizer packageNamed: packageName.
	self
		methods: (self gather methodsForPackage: package)
		classes: (self gather classesForPackage: package)
		packages: { package }
]

{ #category : #'generic api' }
S2Instrumentator >> onPackages: pacakgeCollection [
	self 
		methods: (self gather methodsForPackages: pacakgeCollection)
		classes: (self gather classesForPackages: pacakgeCollection)
		packages: pacakgeCollection copy
]

{ #category : #'generic api' }
S2Instrumentator >> onPackagesMatching: regex [
	| packageCollection |
	packageCollection := self gather packagesForRegex: regex.
	self 
		methods: (self gather methodsForPackages: packageCollection)
		classes: (self gather classesForPackages: packageCollection)
		packages: packageCollection
]

{ #category : #'generic api' }
S2Instrumentator >> onPackagesMatchingExpressions: expressions [
	| packageCollection |
	packageCollection := self gather packagesForRegexExpressions: expressions.
	self 
		methods: (self gather methodsForPackages: packageCollection)
		classes: (self gather classesForPackages: packageCollection)
		packages: packageCollection
]

{ #category : #'generic api' }
S2Instrumentator >> onPackagesNamed: names [
	| packageCollection |
	packageCollection := names collect: [ :name | RPackage organizer packageNamed: name ].
	self 
		methods: (self gather methodsForPackages: packageCollection)
		classes: (self gather classesForPackages: packageCollection)
		packages: packageCollection
]

{ #category : #accessing }
S2Instrumentator >> packages [ 
	^packages copy
]
