Class {
	#name : #Spy2,
	#superclass : #Object,
	#classVars : [
		'DebugSpyFlag'
	],
	#category : #'Spy2-Core-Metamodel'
}

{ #category : #util }
Spy2 class >> clean [
	S2Profiler clean
]

{ #category : #'as yet unclassified' }
Spy2 class >> disableDebugSpy [
	DebugSpyFlag := false
]

{ #category : #'as yet unclassified' }
Spy2 class >> enableDebugSpy [
	"
	self enableDebugSpy
	"
	DebugSpyFlag := true
]

{ #category : #'code generation' }
Spy2 class >> generate: profilerName [
	"Public method to create a new profiler"
	
	"
	self generate: 'PMove' category: 'Spy2-Examples-PMove'
	"
	
	^ self generate: profilerName category: profilerName asString
]

{ #category : #util }
Spy2 class >> generate: profilerName category: aCategory [
	"
	
	Example of usage:
	self generate: 'S2C' category: 'S2py-Counting'
	"
	
	| profiler methodSpy classSpy packageSpy  |
	self assert: [ profilerName first isUppercase ].
	self assert: [ aCategory notEmpty ].
	
	profiler := S2Profiler subclass: profilerName asSymbol
		instanceVariableNames: ''
		classVariableNames: ''
		poolDictionaries: ''
		category: aCategory.
		
	methodSpy := S2Method subclass: (profilerName, 'Method') asSymbol
		instanceVariableNames: ''
		classVariableNames: ''
		poolDictionaries: ''
		category: aCategory.
	
	classSpy := S2Class subclass: (profilerName, 'Class') asSymbol
		instanceVariableNames: ''
		classVariableNames: ''
		poolDictionaries: ''
		category: aCategory.

	packageSpy := S2Package subclass: (profilerName, 'Package') asSymbol
		instanceVariableNames: ''
		classVariableNames: ''
		poolDictionaries: ''
		category: aCategory.
		
	profiler class compile: 'spyClassForPackage', String cr, String tab, ' ^ ', packageSpy name classified: 'hooks'.
	packageSpy class compile: 'spyClassForClass', String cr, String tab, ' ^ ', classSpy name classified: 'hooks'.
	classSpy class compile: 'spyClassForMethod', String cr, String tab, ' ^ ', methodSpy name classified: 'hooks'.
	methodSpy compile: 'beforeRun: methodName with: listOfArguments in: receiver
	"This method is executed before each method of the profiled application.
	 Insert here the instrumentation you would like to perform during the profiling."' classified: 'hooks'.
]

{ #category : #'as yet unclassified' }
Spy2 class >> isDebugSpyEnabled [
	^ DebugSpyFlag ifNil: [ DebugSpyFlag := false ]
]

{ #category : #util }
Spy2 class >> remove [
	self clean
]

{ #category : #metamodel }
Spy2 >> createSpy: anObject [ 
	^ anObject createSpy: self profiler
]

{ #category : #metamodel }
Spy2 >> getSpy: object [

	^ object getSpy: self profiler
]

{ #category : #testing }
Spy2 >> isSpy [

	^ true
]
