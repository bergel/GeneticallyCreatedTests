Class {
	#name : #AbstractSourceCodeGeneration,
	#superclass : #Object,
	#category : #'GeneticallyCreatedTests-Core-SourceCodeGeneration'
}

{ #category : #accessing }
AbstractSourceCodeGeneration >> generateTestsOnClass: aClass [
	"Argument should be the test class that is freshly created"
	self subclassResponsibility
]
