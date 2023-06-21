Class {
	#name : #S2InsertBehaviorPlugin,
	#superclass : #S2ClassPlugin,
	#instVars : [
		'newMethods',
		'selector',
		'classSelectorBlock',
		'behaviorCode'
	],
	#category : #'Spy2-Core-Plugins-Class'
}

{ #category : #'classic plugins' }
S2InsertBehaviorPlugin class >> basicNewPluginOn: aProfiler [
	Warning signal: 'The behavior of the basicNewPlugin has changed, now you must implement the Profiler>>onBasicNew: method that receives the object created as an argument.'.
	^ S2SpecialBehaviorPlugin basicNewPluginOn: aProfiler
]

{ #category : #'classic plugins' }
S2InsertBehaviorPlugin class >> hashPluginOn: aProfiler [

	^ S2SpecialBehaviorPlugin hashPluginOn: aProfiler
]

{ #category : #'classic plugins' }
S2InsertBehaviorPlugin class >> identityHashPluginOn: aProfiler [

	^ S2SpecialBehaviorPlugin identityHashPluginOn: aProfiler
]

{ #category : #'instance creation' }
S2InsertBehaviorPlugin class >> new [
	Error signal: 'Plugin disabled temporaly.'
]

{ #category : #accessing }
S2InsertBehaviorPlugin >> behaviorCode [
	^ behaviorCode
]

{ #category : #accessing }
S2InsertBehaviorPlugin >> behaviorCode: anObject [
	behaviorCode := anObject
]

{ #category : #accessing }
S2InsertBehaviorPlugin >> classSelectorBlock [
	^ classSelectorBlock
]

{ #category : #accessing }
S2InsertBehaviorPlugin >> classSelectorBlock: anObject [
	classSelectorBlock := anObject
]

{ #category : #initialization }
S2InsertBehaviorPlugin >> initialize [

	newMethods := OrderedCollection new.
	classSelectorBlock := [ :classes | self computeRoots: classes ]
]

{ #category : #hooks }
S2InsertBehaviorPlugin >> installOn: classes [
	(self classSelectorBlock value: classes) do: [ :cls | 
		cls methodDict  
			at: selector 
			ifAbsent: [ cls compile: behaviorCode.
							newMethods add: (cls >> selector) ] ].
	^ classes
]

{ #category : #accessing }
S2InsertBehaviorPlugin >> newMethods [
	^ newMethods
]

{ #category : #accessing }
S2InsertBehaviorPlugin >> selector [
	^ selector
]

{ #category : #accessing }
S2InsertBehaviorPlugin >> selector: anObject [
	selector := anObject
]

{ #category : #hooks }
S2InsertBehaviorPlugin >> uninstall [

	newMethods do: [ :method | method isInstalled ifTrue: [ method removeFromSystem ] ].
	self initialize. 
]
