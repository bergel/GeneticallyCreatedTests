Class {
	#name : #GCTMethodProxy,
	#superclass : #Object,
	#instVars : [
		'originalMethod'
	],
	#category : 'GeneticallyCreatedTests-Profiling-Core'
}

{ #category : #evaluation }
GCTMethodProxy >> doesNotUnderstand: aMessage [
	^ originalMethod perform: aMessage selector withArguments: aMessage arguments
]

{ #category : #evaluation }
GCTMethodProxy >> hookRun: aSelector with: anArray in: aReceiver [
	"Meant to be overriden"
]

{ #category : #accessing }
GCTMethodProxy >> originalMethod [

	^ originalMethod
]

{ #category : #accessing }
GCTMethodProxy >> originalMethod: aCompiledMethod [

	originalMethod := aCompiledMethod
]

{ #category : #evaluation }
GCTMethodProxy >> run: aSelector with: anArray in: aReceiver [
	self hookRun: aSelector with: anArray in: aReceiver.
	^ aReceiver withArgs: anArray executeMethod: originalMethod
]
