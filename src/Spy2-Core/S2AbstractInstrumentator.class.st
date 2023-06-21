"
A S2AbstractInstrumentator is the responsible of method instrumentation in Spy2. This class represent the current instrumentation state of a profiler, is responsible for correct changes of instrumented methods, apply the plugins and the cleaning of the system.

For managing the methods, classes and packages instrumented it uses Ring representations, which do not reference the concrete Compiled Method or class, instead it has a reference for the further lookup in the system, always having a consistent reference to the current version in the system.
"
Class {
	#name : #S2AbstractInstrumentator,
	#superclass : #Object,
	#instVars : [
		'profiler'
	],
	#classVars : [
		'MethodBlacklist'
	],
	#category : #'Spy2-Core-Instrumentator'
}

{ #category : #'private - method template' }
S2AbstractInstrumentator class >> generateTemplates [
	"
	self generateTemplates
	"
	| argString parameterString |
	self class compileSilently: 'with0Arg ', String cr, (self templateCode expandMacrosWith: '#()') classified: 'private - method template'.
	1 to: 15 do: [ :i |
		parameterString := ''.
		argString := '{'.
		1 to: i do: [ :ii | 
			parameterString := parameterString, 'arg: ', 'v', ii printString, ' '.
			argString := argString, 'v', ii printString, '.'].
		
		argString := argString allButLast, '}'.

		self class 
				compile: 'with', i printString, parameterString, String cr, (self templateCode expandMacrosWith: argString)
				classified: 'private - method template'.
	]
]

{ #category : #'private - profiler' }
S2AbstractInstrumentator class >> initializeProfiler: aProfiler [
	aProfiler instrumentator: (S2VoidInstrumentator new 
											profiler: aProfiler;
											yourself)
]

{ #category : #blacklist }
S2AbstractInstrumentator class >> methodBlacklist [
	"
	self resetBlacklist
	"
	^ MethodBlacklist ifNil: [ MethodBlacklist := Set new.
		MethodBlacklist 
			addAll: self package methods;
			add: SequenceableCollection >> #grownBy:;
			add: SequenceableCollection >> #at:ifAbsent:;
			add: SequenceableCollection class >> #ofSize:;
			add: ArrayedCollection >> #size;
			add: Object >> #at:;
			add: Object >> #at:put:;
			add: Object >> #species;
			add: Array class >> #new:.
		MethodBlacklist := MethodBlacklist collect: #asSpyRingDefinition ]
]

{ #category : #blacklist }
S2AbstractInstrumentator class >> resetBlacklist [
	MethodBlacklist := nil
]

{ #category : #'private - method template' }
S2AbstractInstrumentator class >> templateCode [
	^ '^ #metaObject primitiveRun: #selector with: <1s> in: self  '
]

{ #category : #'private - method template' }
S2AbstractInstrumentator class >> templateMethodForNumberOfArguments: numberOfArguments [
	^ S2AbstractInstrumentator class >> (#(
			#with0Arg
			#with1arg:
			#with2arg:arg:
			#with3arg:arg:arg:
			#with4arg:arg:arg:arg:
			#with5arg:arg:arg:arg:arg:
			#with6arg:arg:arg:arg:arg:arg:
			#with7arg:arg:arg:arg:arg:arg:arg:
			#with8arg:arg:arg:arg:arg:arg:arg:arg:
			#with9arg:arg:arg:arg:arg:arg:arg:arg:arg:
			#with10arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:
			#with11arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:
			#with12arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:
			#with13arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:
			#with14arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:
			#with15arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:
			) at: (numberOfArguments + 1))
]

{ #category : #'private - method template' }
S2AbstractInstrumentator class >> templateMethods [
	^ #(
			#with0Arg
			#with1arg:
			#with2arg:arg:
			#with3arg:arg:arg:
			#with4arg:arg:arg:arg:
			#with5arg:arg:arg:arg:arg:
			#with6arg:arg:arg:arg:arg:arg:
			#with7arg:arg:arg:arg:arg:arg:arg:
			#with8arg:arg:arg:arg:arg:arg:arg:arg:
			#with9arg:arg:arg:arg:arg:arg:arg:arg:arg:
			#with10arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:
			#with11arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:
			#with12arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:
			#with13arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:
			#with14arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:
			#with15arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:arg:
			) collect: [:k | self class >> k ]
]

{ #category : #'private - method template' }
S2AbstractInstrumentator class >> with0Arg [ 
^ #metaObject primitiveRun: #selector with: #() in: self  
]

{ #category : #'private - method template' }
S2AbstractInstrumentator class >> with10arg: v1 arg: v2 arg: v3 arg: v4 arg: v5 arg: v6 arg: v7 arg: v8 arg: v9 arg: v10 [ 
^ #metaObject primitiveRun: #selector with: {v1.v2.v3.v4.v5.v6.v7.v8.v9.v10} in: self  
]

{ #category : #'private - method template' }
S2AbstractInstrumentator class >> with11arg: v1 arg: v2 arg: v3 arg: v4 arg: v5 arg: v6 arg: v7 arg: v8 arg: v9 arg: v10 arg: v11 [ 
^ #metaObject primitiveRun: #selector with: {v1.v2.v3.v4.v5.v6.v7.v8.v9.v10.v11} in: self  
]

{ #category : #'private - method template' }
S2AbstractInstrumentator class >> with12arg: v1 arg: v2 arg: v3 arg: v4 arg: v5 arg: v6 arg: v7 arg: v8 arg: v9 arg: v10 arg: v11 arg: v12 [ 
^ #metaObject primitiveRun: #selector with: {v1.v2.v3.v4.v5.v6.v7.v8.v9.v10.v11.v12} in: self  
]

{ #category : #'private - method template' }
S2AbstractInstrumentator class >> with13arg: v1 arg: v2 arg: v3 arg: v4 arg: v5 arg: v6 arg: v7 arg: v8 arg: v9 arg: v10 arg: v11 arg: v12 arg: v13 [ 
^ #metaObject primitiveRun: #selector with: {v1.v2.v3.v4.v5.v6.v7.v8.v9.v10.v11.v12.v13} in: self  
]

{ #category : #'private - method template' }
S2AbstractInstrumentator class >> with14arg: v1 arg: v2 arg: v3 arg: v4 arg: v5 arg: v6 arg: v7 arg: v8 arg: v9 arg: v10 arg: v11 arg: v12 arg: v13 arg: v14 [ 
^ #metaObject primitiveRun: #selector with: {v1.v2.v3.v4.v5.v6.v7.v8.v9.v10.v11.v12.v13.v14} in: self  
]

{ #category : #'private - method template' }
S2AbstractInstrumentator class >> with15arg: v1 arg: v2 arg: v3 arg: v4 arg: v5 arg: v6 arg: v7 arg: v8 arg: v9 arg: v10 arg: v11 arg: v12 arg: v13 arg: v14 arg: v15 [ 
^ #metaObject primitiveRun: #selector with: {v1.v2.v3.v4.v5.v6.v7.v8.v9.v10.v11.v12.v13.v14.v15} in: self  
]

{ #category : #'private - method template' }
S2AbstractInstrumentator class >> with1arg: v1 [ 
^ #metaObject primitiveRun: #selector with: {v1} in: self  
]

{ #category : #'private - method template' }
S2AbstractInstrumentator class >> with2arg: v1 arg: v2 [ 
^ #metaObject primitiveRun: #selector with: {v1.v2} in: self  
]

{ #category : #'private - method template' }
S2AbstractInstrumentator class >> with3arg: v1 arg: v2 arg: v3 [ 
^ #metaObject primitiveRun: #selector with: {v1.v2.v3} in: self  
]

{ #category : #'private - method template' }
S2AbstractInstrumentator class >> with4arg: v1 arg: v2 arg: v3 arg: v4 [ 
^ #metaObject primitiveRun: #selector with: {v1.v2.v3.v4} in: self  
]

{ #category : #'private - method template' }
S2AbstractInstrumentator class >> with5arg: v1 arg: v2 arg: v3 arg: v4 arg: v5 [ 
^ #metaObject primitiveRun: #selector with: {v1.v2.v3.v4.v5} in: self  
]

{ #category : #'private - method template' }
S2AbstractInstrumentator class >> with6arg: v1 arg: v2 arg: v3 arg: v4 arg: v5 arg: v6 [ 
^ #metaObject primitiveRun: #selector with: {v1.v2.v3.v4.v5.v6} in: self  
]

{ #category : #'private - method template' }
S2AbstractInstrumentator class >> with7arg: v1 arg: v2 arg: v3 arg: v4 arg: v5 arg: v6 arg: v7 [ 
^ #metaObject primitiveRun: #selector with: {v1.v2.v3.v4.v5.v6.v7} in: self  
]

{ #category : #'private - method template' }
S2AbstractInstrumentator class >> with8arg: v1 arg: v2 arg: v3 arg: v4 arg: v5 arg: v6 arg: v7 arg: v8 [ 
^ #metaObject primitiveRun: #selector with: {v1.v2.v3.v4.v5.v6.v7.v8} in: self  
]

{ #category : #'private - method template' }
S2AbstractInstrumentator class >> with9arg: v1 arg: v2 arg: v3 arg: v4 arg: v5 arg: v6 arg: v7 arg: v8 arg: v9 [ 
^ #metaObject primitiveRun: #selector with: {v1.v2.v3.v4.v5.v6.v7.v8.v9} in: self  
]

{ #category : #adding }
S2AbstractInstrumentator >> addClass: cls [
	^ S2Instrumentator new
		methods: self methods , (self gather methodsForClass: cls)
		classes: self classes , { cls }
		packages: self packages
			
]

{ #category : #adding }
S2AbstractInstrumentator >> addClasses: clsCollection [
	^ S2Instrumentator new
		methods: self methods , (self gather methodsForClasses: clsCollection)
		classes: self classes , clsCollection asArray
		packages: self packages
			
]

{ #category : #adding }
S2AbstractInstrumentator >> addMethod: method [
	^ S2Instrumentator new
		methods: self methods , { method }
		classes: self classes
		packages: self packages
			
]

{ #category : #adding }
S2AbstractInstrumentator >> addMethods: methods [
	^ S2Instrumentator new
		methods: self methods , methods asArray
		classes: self classes
		packages: self packages
			
]

{ #category : #adding }
S2AbstractInstrumentator >> addPackage: package [
	^ S2Instrumentator new
		methods: self methods , (self gather methodsForPackage: package)
		classes: self classes , (self gather classesForPackage: package)
		packages: self packages , { package }
			
]

{ #category : #adding }
S2AbstractInstrumentator >> addPackages: packageCollection [
	^ S2Instrumentator new
		methods: self methods , (self gather methodsForPackages: packageCollection)
		classes: self classes , (self gather classesForPackages: packageCollection)
		packages: self packages , packageCollection asArray
			
]

{ #category : #hook }
S2AbstractInstrumentator >> applyOn: aProfiler [
	self assert: profiler isNil.
	"self assert: S2Lock isLocked not."
	profiler := aProfiler.
	"[ "
		[	S2Lock lock. 	
			self profiler invalidateCaches.
			self applyOnAction: aProfiler.
			self profiler computeCaches ] 
		ensure: [ 
			S2Lock unlock.
			profiler instrumentator: self ]" ] 
		on: Error do: [ :e |
			Error signal: 'Critical error on Spy2 instrumentation. Proceed to clean System.'.
			S2Profiler remove.
			self class initializeProfiler: profiler ]"
]

{ #category : #hook }
S2AbstractInstrumentator >> applyOnAction: aProfiler [
	self assertBlacklist.
	self instrumentChangesFrom: profiler instrumentator.
]

{ #category : #blacklist }
S2AbstractInstrumentator >> assertBlacklist [
	"self assert: (self classes noneSatisfy: [ :cls | cls package name = 'Kernel' ]).
	self assert: (self methods noneSatisfy: [ :m | m package name = 'Kernel' ])"
]

{ #category : #'plugins - accessing' }
S2AbstractInstrumentator >> classPlugins [
	^ self profiler classPlugins
]

{ #category : #accessing }
S2AbstractInstrumentator >> classes [
	self subclassResponsibility 
]

{ #category : #utils }
S2AbstractInstrumentator >> gather [
	^ S2Gatherer uniqueInstance
]

{ #category : #'private - template method' }
S2AbstractInstrumentator >> installOnMethod: method [
	| spyMethod templateMethod|
	self assert: [ method isSpy not ] description: 
	'Trying to instrument a previously instrumented method.
	To clean up Spy please run: S2Profiler remove'.

	spyMethod := self profiler createSpy: method.
	spyMethod originalMethod: method.
	
	method selector flushCache.
	templateMethod := self class templateMethodForNumberOfArguments: method numArgs.
	templateMethod := templateMethod copyFor: method methodClass.
	
	templateMethod replaceLiterals: 
		{#metaObject -> spyMethod. 
		 #selector -> method selector}.
	templateMethod selector: method selector.
	method methodClass methodDictionary at: method selector put: templateMethod.
	
	spyMethod instrumentedMethod: templateMethod.
	
	^ templateMethod
]

{ #category : #'private - utility' }
S2AbstractInstrumentator >> installProfilerPlugins [
	self profilerPlugins do: #install
]

{ #category : #'private - action' }
S2AbstractInstrumentator >> instrumentChangesFrom: oldInstrumentator [
	self uninstallFromMethods: (oldInstrumentator methods difference: self methods).
	self uninstallFromClasses: (oldInstrumentator classes difference: self classes).
	oldInstrumentator isVoidInstrumentator 
		ifTrue: [ 
			self profiler beforeInstalling.
			self installProfilerPlugins ].
	self instrumentClasses: (self classes difference: oldInstrumentator classes).
	self instrumentMethods: (self methods difference: oldInstrumentator methods).
	oldInstrumentator isVoidInstrumentator 
		ifTrue: [ self profiler beforeProfiling ].
]

{ #category : #'private - action' }
S2AbstractInstrumentator >> instrumentClasses: ringClasses [ 
	self classPlugins do: [:plugin |
		ringClasses do: [ :ringClass | | cls |
			cls := ringClass realClass.
			(cls isNotNil and: [ cls isTrait not ]) ifTrue: [ plugin installOn: cls ].
			self profiler createSpy: cls ] ]
]

{ #category : #'private - action' }
S2AbstractInstrumentator >> instrumentMethods: ringMethods [
	ringMethods do: [ :ringMethod | | method |
		ringMethod compiledMethod ifNotNil: [ 
			self methodPlugins do: [:plugin | plugin installOn: ringMethod compiledMethod ].
			method := ringMethod compiledMethod.
			self installOnMethod: method.
			 ] ]
	
]

{ #category : #testing }
S2AbstractInstrumentator >> isVoidInstrumentator [
	^ false
]

{ #category : #'plugins - accessing' }
S2AbstractInstrumentator >> methodPlugins [
	^ self profiler methodPlugins
]

{ #category : #accessing }
S2AbstractInstrumentator >> methods [
	self subclassResponsibility
]

{ #category : #accessing }
S2AbstractInstrumentator >> packages [
	self subclassResponsibility 
]

{ #category : #accessing }
S2AbstractInstrumentator >> profiler [
	^ profiler
]

{ #category : #'plugins - accessing' }
S2AbstractInstrumentator >> profiler: aProfiler [
	profiler := aProfiler
]

{ #category : #'plugins - accessing' }
S2AbstractInstrumentator >> profilerPlugins [
	^ self profiler profilerPlugins
]

{ #category : #utils }
S2AbstractInstrumentator >> rejectBlacklistFromMethods: methodCollection [
	^ self rejectTraitsFromMethods: (methodCollection difference: self class methodBlacklist)
]

{ #category : #utils }
S2AbstractInstrumentator >> rejectTraitsFromClasses: classCollection [
	^ classCollection reject: #isTrait
]

{ #category : #utils }
S2AbstractInstrumentator >> rejectTraitsFromMethods: methodCollection [
	^ methodCollection reject: [ :m | m methodClass isTrait ]
]

{ #category : #removing }
S2AbstractInstrumentator >> removeClass: cls [
	^ S2Instrumentator new
		methods: (self methods difference: ((self gather methodsForClass: cls) collect: #asFullRingDefinition))
		classes: (self classes difference: { cls asFullRingDefinition })
		packages: self packages
]

{ #category : #removing }
S2AbstractInstrumentator >> removeClasses: clsCollection [
	^ S2Instrumentator new
		methods: 
		(self methods 
			difference: ((self gather methodsForClasses: clsCollection) collect: #asFullRingDefinition))
		classes: (self classes difference: (clsCollection collect: #asFullRingDefinition))
		packages: self packages
]

{ #category : #removing }
S2AbstractInstrumentator >> removeMethod: method [
	^ S2Instrumentator new
		methods: (self methods difference: {method asFullRingDefinition})
		classes: self classes
		packages: self packages
]

{ #category : #removing }
S2AbstractInstrumentator >> removeMethods: methodCollection [
	^ S2Instrumentator new
		methods: (self methods difference: (methodCollection collect: #asFullRingDefinition))
		classes: self classes
		packages: self packages
]

{ #category : #removing }
S2AbstractInstrumentator >> removePackage: package [
	^ S2Instrumentator new
		methods: 
			(self methods 
				difference: ((self gather methodsForPackage: package) collect: #asFullRingDefinition))
		classes: 
			(self classes 
				difference: ((self gather classesForPackage: package) collect: #asFullRingDefinition))
		packages: (self packages difference: {package asFullRingDefinition})
]

{ #category : #removing }
S2AbstractInstrumentator >> removePackages: packageCollection [
	^ S2Instrumentator new
		methods: 
			(self methods 
				difference: ((self gather methodsForPackages: packageCollection) 
										collect: #asFullRingDefinition))
		classes: (self classes 
			difference: ((self gather classesForPackages: packageCollection) 
										collect: #asFullRingDefinition))
		packages: (self packages difference: (packageCollection collect: #asFullRingDefinition))
]

{ #category : #'private - action' }
S2AbstractInstrumentator >> uninstallFromClasses: ringClasses [ 
	self classPlugins reverse ensureDo: [:plugin | 
		ringClasses do: [ :ringClass | | cls |
			cls := ringClass realClass.
			cls isNotNil ifTrue: [ 
				plugin uninstallFrom: cls ] ] ]
]

{ #category : #'private - action' }
S2AbstractInstrumentator >> uninstallFromMethods: ringMethods [
	ringMethods do: [ :ringMethod | | method |
		method := ringMethod compiledMethod.
		(method isNotNil and: [ method isSpy ]) ifTrue: [ | originalMethod |
				originalMethod := method originalMethod.
				originalMethod methodClass methodDictionary 
					at: originalMethod selector 
					put: originalMethod.
				originalMethod flushCache.
				self methodPlugins reverse ensureDo: [:plugin | 
					plugin uninstallFrom: ringMethod compiledMethod ].
			 ].
		 ]
	
]

{ #category : #'private - utility' }
S2AbstractInstrumentator >> uninstallProfilerPlugins [
	self profilerPlugins reverse ensureDo: #uninstall
]
