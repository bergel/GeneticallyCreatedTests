Class {
	#name : #S2StackFrame,
	#superclass : #Object,
	#instVars : [
		'spyMethod',
		'arguments',
		'receiver',
		'sender'
	],
	#category : #'Spy2-Core-Utils'
}

{ #category : #'instance creation' }
S2StackFrame class >> spyMethod: aMethod arguments: arguments receiver: receiver [

	^ self new
		spyMethod: aMethod;
		arguments: arguments;
		receiver: receiver;
		yourself
]

{ #category : #accessing }
S2StackFrame >> arguments [
	^ arguments
]

{ #category : #accessing }
S2StackFrame >> arguments: anObject [
	arguments := anObject
]

{ #category : #accessing }
S2StackFrame >> receiver [
	^ receiver
]

{ #category : #accessing }
S2StackFrame >> receiver: anObject [
	receiver := anObject
]

{ #category : #accessing }
S2StackFrame >> sender [
	^ sender
]

{ #category : #accessing }
S2StackFrame >> sender: anObject [
	sender := anObject
]

{ #category : #accessing }
S2StackFrame >> spyMethod [
	^ spyMethod
]

{ #category : #accessing }
S2StackFrame >> spyMethod: anObject [
	spyMethod := anObject
]

{ #category : #accessing }
S2StackFrame >> spySender [

	^ self sender
]
