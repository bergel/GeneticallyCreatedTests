Class {
	#name : #S2ReplaceLiteralsPlugin,
	#superclass : #S2MethodPlugin,
	#instVars : [
		'translationForward',
		'translationBackward',
		'translation',
		'changes'
	],
	#category : #'Spy2-Core-Plugins-Methods'
}

{ #category : #'instance creation' }
S2ReplaceLiteralsPlugin class >> on: aProfiler usingTranslations: associations [
	|plugin|
	plugin := self on: aProfiler.
	plugin generateTranslations: associations.
	^ plugin
]

{ #category : #initialization }
S2ReplaceLiteralsPlugin >> generateTranslations: associations [
	associations do: [ :assoc | translation at: assoc key put: assoc value ].
]

{ #category : #initialization }
S2ReplaceLiteralsPlugin >> initialize [
	super initialize.
	translation := Dictionary new.
	changes := OrderedCollection new
]

{ #category : #hooks }
S2ReplaceLiteralsPlugin >> installOn: aMethod [
	self replaceLiteralsOf: aMethod
]

{ #category : #action }
S2ReplaceLiteralsPlugin >> replaceLiteralsOf: method [
	(1 to: method numLiterals - 2) do: [ :index | | literal|
		literal := method literalAt: index.
		(translation includesKey: literal) ifTrue: [
				changes add: { method . index . literal }.
				method literalAt: index put: (translation at: literal).
			] ].
]

{ #category : #hooks }
S2ReplaceLiteralsPlugin >> uninstallFrom: aMethod [
	"A change is an array composed by #( method literalIndex originalLiteral)"
	| methodChanges |
	methodChanges := changes select: [ :chg | chg first = aMethod ].
	methodChanges do: [ :chg | |method index originalLiteral|
		method := chg first.
		index := chg second.
		originalLiteral := chg third.
		
		method literalAt: index put: originalLiteral ]
]
