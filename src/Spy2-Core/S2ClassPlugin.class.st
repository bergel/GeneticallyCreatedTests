Class {
	#name : #S2ClassPlugin,
	#superclass : #S2Plugin,
	#category : #'Spy2-Core-Plugins-Class'
}

{ #category : #utility }
S2ClassPlugin >> computeRoots: classes [
	| roots |
	roots := classes copy asOrderedCollection.
	classes do: [:aClass | aClass allSubclasses do: [ :el | roots remove: el ifAbsent: [ ] ] ].
	^ roots
]

{ #category : #hooks }
S2ClassPlugin >> installOn: class [
	self subclassResponsibility
]

{ #category : #hooks }
S2ClassPlugin >> uninstall [
	self deprecated: 'Now you should implement uninstallFrom:'.
	self subclassResponsibility
]

{ #category : #hooks }
S2ClassPlugin >> uninstallFrom: aClass [
	self subclassResponsibility
]
