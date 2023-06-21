Class {
	#name : #S2MethodPlugin,
	#superclass : #S2Plugin,
	#category : #'Spy2-Core-Plugins-Methods'
}

{ #category : #hooks }
S2MethodPlugin >> installOn: method [
	self subclassResponsibility
]

{ #category : #hooks }
S2MethodPlugin >> uninstallFrom: aMethod [
	self subclassResponsibility
]
