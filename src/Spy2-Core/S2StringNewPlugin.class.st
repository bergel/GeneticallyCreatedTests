Class {
	#name : #S2StringNewPlugin,
	#superclass : #S2ProfilerPlugin,
	#category : #'Spy2-Core-Plugins-Profiler'
}

{ #category : #template }
S2StringNewPlugin class >> templateNew: sizeRequested [ 
	"
	INSTRUMENTED METHOD
	"
	| value |
	value := super new: sizeRequested.
	[ #profiler afterStringNew: value ] spyProtected.
	^ value
]

{ #category : #hooks }
S2StringNewPlugin >> addToSpyMetamodel [

	profiler createSpy: String
]

{ #category : #hooks }
S2StringNewPlugin >> install [
	self addToSpyMetamodel.
	[ 
	self assert: (ByteString class methodDictionary includesKey: #new:) not.
	self assert: profiler isNotNil.
	self primitiveInstall.
	] valueUnpreemptively
]

{ #category : #private }
S2StringNewPlugin >> primitiveInstall [

	|template|
	template := S2StringNewPlugin class >> #templateNew:.
	#new: flushCache.
	template := template copyFor: ByteString class.
	template replaceLiterals:
		{ 
		template selector -> #new: .
		#profiler -> self profiler
		}.

	ByteString class methodDictionary at: #new: put: template.
	#new: flushCache.

]

{ #category : #hooks }
S2StringNewPlugin >> uninstall [
	ByteString class methodDictionary removeKey: #new: ifAbsent: [  ]
]
