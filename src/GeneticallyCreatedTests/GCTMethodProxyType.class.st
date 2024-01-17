Class {
	#name : #GCTMethodProxyType,
	#superclass : #GCTMethodProxy,
	#instVars : [
		'returnType',
		'argTypes',
		'isMarked'
	],
	#category : #'GeneticallyCreatedTests-Profiling-Core'
}

{ #category : #accessing }
GCTMethodProxyType >> argTypes [
	^ argTypes
]

{ #category : #evaluation }
GCTMethodProxyType >> hookRun: aSelector with: anArray in: aReceiver [
	argTypes := anArray collect: #class
]

{ #category : #accessing }
GCTMethodProxyType >> initialize [
	super initialize.
	argTypes := #().
	isMarked := false
]

{ #category : #accessing }
GCTMethodProxyType >> isMarked [
	^ isMarked
]

{ #category : #accessing }
GCTMethodProxyType >> returnType [
	^ returnType
]

{ #category : #evaluation }
GCTMethodProxyType >> run: aSelector with: anArray in: aReceiver [
	| result |
	result := super run: aSelector with: anArray in: aReceiver.
	returnType := result class.
	isMarked := true.
	^ result

]
