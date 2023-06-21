Class {
	#name : #S2PointNewPlugin,
	#superclass : #S2ProfilerPlugin,
	#instVars : [
		'originalMethods'
	],
	#category : #'Spy2-Core-Plugins-Profiler'
}

{ #category : #template }
S2PointNewPlugin class >> @ y [
	"
	INSTRUMENTED METHOD
	" 
	^Point x: self y: y
]

{ #category : #template }
S2PointNewPlugin class >> templateR: xInteger Degrees: yInteger [ 
	"
	INSTRUMENTED METHOD
	"
	| value |
	value := self basicNew setR: xInteger degrees: yInteger.
	[ #profiler afterPointNew: value ] spyProtected.
	^ value
]

{ #category : #template }
S2PointNewPlugin class >> templateX: xInteger Y: yInteger [ 
	"
	INSTRUMENTED METHOD
	"
	| value |
	value := self basicNew setX: xInteger setY: yInteger.
	[ #profiler afterPointNew: value ] spyProtected.
	^ value
]

{ #category : #hooks }
S2PointNewPlugin >> addToSpyMetamodel [

	profiler createSpy: Point
]

{ #category : #'as yet unclassified' }
S2PointNewPlugin >> initialize [

	originalMethods := OrderedCollection new.
]

{ #category : #hooks }
S2PointNewPlugin >> install [

	self addToSpyMetamodel.
	[ 
	self assert: profiler isNotNil.
	self 	primitiveInstallTemplate: S2PointNewPlugin class >> #templateX:Y: 
			forMethod: Point class >> #x:y:.
	self 	primitiveInstallTemplate: S2PointNewPlugin class >> #templateR:Degrees: 
			forMethod: Point class >> #r:degrees:.
	self 	primitiveInstallTemplate: S2PointNewPlugin class >> #@ 
			forMethod: Number >> #@.
	] valueUnpreemptively
]

{ #category : #'as yet unclassified' }
S2PointNewPlugin >> primitiveInstallTemplate: aTemplate forMethod: aMethod [
	| template |
	self assert: aMethod isSpy not.
	self storeOriginalMethod: aMethod.
	template := aTemplate copyFor: aMethod methodClass.
	template replaceLiterals:
		{ 
		template selector -> aMethod selector.
		#profiler -> self profiler
		}.
	aMethod methodClass methodDictionary at: aMethod selector put: template.
	aMethod selector flushCache.
]

{ #category : #'as yet unclassified' }
S2PointNewPlugin >> storeOriginalMethod: aMethod [

	originalMethods add: aMethod
]

{ #category : #hooks }
S2PointNewPlugin >> uninstall [
	originalMethods do: [ :m | 
		m methodClass methodDict at: m selector put: m. 
		m selector flushCache ]
]
