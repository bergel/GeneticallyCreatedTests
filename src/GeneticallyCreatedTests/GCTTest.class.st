Class {
	#name : #GCTTest,
	#superclass : #TestCase,
	#instVars : [
		'gct'
	],
	#category : #'GeneticallyCreatedTests-Core'
}

{ #category : #running }
GCTTest >> setUp [
	super setUp.
	gct := GCT new.
	gct random: (Random seed: 42).
	gct targetClass: MyPoint 
]

{ #category : #tests }
GCTTest >> testCreationStatement [
	self assert: gct buildObjectCreationStatement equals: { #v1 . MyPoint . #new }
]

{ #category : #tests }
GCTTest >> testCreationStatement02 [
	gct addObjectCreationStatement.
	self assert: gct chromosome size equals: 1.
	self assert: gct chromosome first equals: { #v1 . MyPoint . #new }.
	self assert: (gct typeOfVariable: #v1) == MyPoint
]
