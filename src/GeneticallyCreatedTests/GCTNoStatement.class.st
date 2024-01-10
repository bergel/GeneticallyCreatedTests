Class {
	#name : #GCTNoStatement,
	#superclass : #GCTStatement,
	#category : 'GeneticallyCreatedTests-Core-CodeGeneration'
}

{ #category : #building }
GCTNoStatement >> buildCodeOn: stream [
	"do nothing"
]

{ #category : #initialization }
GCTNoStatement >> initialize [
	super initialize.
	type := self class
]
