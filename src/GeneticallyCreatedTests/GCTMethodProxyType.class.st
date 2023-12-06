Class {
	#name : 'GCTMethodProxyType',
	#superclass : 'GCTMethodProxy',
	#instVars : [
		'returnType',
		'argTypes'
	],
	#category : 'GeneticallyCreatedTests-Profiling-Core',
	#package : 'GeneticallyCreatedTests',
	#tag : 'Profiling-Core'
}

{ #category : 'accessing' }
GCTMethodProxyType >> argTypes [
	^ argTypes
]

{ #category : 'evaluation' }
GCTMethodProxyType >> hookRun: aSelector with: anArray in: aReceiver [
	argTypes := anArray collect: #class
]

{ #category : 'accessing' }
GCTMethodProxyType >> initialize [
	super initialize.
	argTypes := #()
]

{ #category : 'evaluation' }
GCTMethodProxyType >> run: aSelector with: anArray in: aReceiver [
	| result |
	result := super run: aSelector with: anArray in: aReceiver.
	returnType := result class.
	^ result

]
