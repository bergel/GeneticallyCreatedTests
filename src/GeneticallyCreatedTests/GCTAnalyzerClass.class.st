Class {
	#name : #GCTAnalyzerClass,
	#superclass : #S2Class,
	#category : #'GeneticallyCreatedTests-Profiling-TypeProfiler'
}

{ #category : #hooks }
GCTAnalyzerClass class >> spyClassForMethod [
	 ^ GCTAnalyzerMethod
]

{ #category : #'as yet unclassified' }
GCTAnalyzerClass >> allClassesUsedAsArguments [
	^ ((self methods select: [ :m | m signature notNil ]) flatCollect: [ :m | m signature third ]) asSet asArray collect: [ :clsName | Smalltalk at: clsName ]
]
