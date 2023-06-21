Class {
	#name : #S2Profiler,
	#superclass : #Spy2,
	#instVars : [
		'packages',
		'allClassesAsDictionaryCache',
		'allMethodsCache',
		'unitTestResult',
		'allNonAbstractMethodsCache',
		'methodPlugins',
		'classPlugins',
		'profilerPlugins',
		'allClassesCache',
		'instrumentator'
	],
	#classVars : [
		'LastProfile'
	],
	#category : #'Spy2-Core-Metamodel'
}

{ #category : #'public - profiling' }
S2Profiler class >> addBracketsTo: codeAsString [
	| str |
	str := WriteStream on: String new.
	str nextPut: $[.
	str nextPutAll: codeAsString.
	str nextPut: $].
	^ str contents
]

{ #category : #util }
S2Profiler class >> clean [
	self removeAllTemplates.
	self hasSlots ifTrue: [self cleanSlots].
]

{ #category : #'public - comparison' }
S2Profiler class >> cleanGlobal [
	self setForComparison: nil
]

{ #category : #util }
S2Profiler class >> cleanSlots [
	self removeAllSlotsFromClasses.
	self recompileMethodsWithSlots.
	
]

{ #category : #'private - method template' }
S2Profiler class >> generateTemplates [
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

{ #category : #'public - profiling' }
S2Profiler class >> getCompiledBlockFromCodeAsString: codeAsString [
	| newCode |
	newCode := self addBracketsTo: codeAsString.
	^ OpalCompiler evaluate: newCode
]

{ #category : #util }
S2Profiler class >> hasSlots [
	^ #('Pharo4.0' 'Pharo5.0' 'Pharo6.0') includes: Smalltalk version
]

{ #category : #util }
S2Profiler class >> isDangerous: aClass [
	self assert: [ aClass theNonMetaClass == aClass ] description: 'Can only be called on non meta class'.
"	(aClass inheritsFrom: Spy) ifTrue: [ ^ true ].
	true ifTrue: [ ^ false ].	"
		
	"Cannot instrument a configuration"
	(aClass name beginsWith: 'ConfigurationOf') ifTrue: [ ^ true ].  
	
	"Can instrument the scenario example, even it belongs to Spy"
	(aClass category beginsWith: 'S2py-ScenarioExample') ifTrue: [ ^ false ].

"	({ByteSymbol . String . Symbol . MethodReference . MorphicToolBuilder} includes: aClass)
		ifTrue: [ ^ true ]."

	(#('S2py' 'Announcements' 'Balloon' 'Collections' 'CollectionsTests' 'Compiler' 'CompilerTests' 'Compression' 'DeprecatedPreferences' 'Exceptions' 'Files' 'FixUnderscores' 'FreeType' 'FreeTypeSubPixelAntiAliasing' 'FreeTypeTests' 'Gofer' 'Graphics' 'GraphicsTests' 'HostMenus' 'Kernel' 'KernelTests' 'MCDirtyPackage' 'MenuRegistration' 'Monticello' 'MonticelloConfigurations' 'MonticelloGUI' 'MonticelloMocks' 'Morphic' 'MorphicTests' 'Multilingual' 'MultilingualTests' 
	"'Network' 'NetworkTests' "
	'ObjectMetaTools' 'PackageInfo' 'PinesoftEnhancementsForFreetype' 'Polymorph' 'PreferenceBrowser' 'ST80' 'SUnit' 'SUnitGUI' 'ScriptLoader' 'ScriptLoader11' 'Settings' 'System' 'Tests' 'ToolBuilder' 'Tools' 'ToolsTest' 'Traits' 'TrueType' 'VB') anySatisfy: [ :cat | aClass category beginsWith: cat ])
		ifTrue: [ ^ true ].
	^ false		
"	^ aClass isCollection
		or: [ ((Smalltalk specialObjectsArray select: #isBehavior) includes: aClass) ]
"
]

{ #category : #util }
S2Profiler class >> isNotDangerous: aClass [
	^ (self isDangerous: aClass) not
]

{ #category : #'public - comparison' }
S2Profiler class >> isReadyForComparison [
	"Return true if there is a profile for comparison"
	^ self lastProfile notNil
]

{ #category : #'public - comparison' }
S2Profiler class >> lastProfile [
	^ LastProfile
]

{ #category : #util }
S2Profiler class >> log: aString [
	Transcript show: 'Running: ', aString asString; cr.
]

{ #category : #'ui - comparison' }
S2Profiler class >> menuCommandOn: aBuilder [
	(aBuilder item: #'Reset comparison profiler')
		order: 0.1; 
		parent: #Hapao;
		label: 'Reset comparison profiler';
		action: [ self cleanGlobal ]
]

{ #category : #util }
S2Profiler class >> nonDangerousClasses [
	^ Smalltalk allClasses select: [:cls | S2Profiler isNotDangerous: cls ]
]

{ #category : #'public - profiling' }
S2Profiler class >> profile: aBlock onClass: aClass [

	^ self new profile: aBlock onClass: aClass
]

{ #category : #'public - profiling' }
S2Profiler class >> profile: aBlock onClassCategory: classCategory [

	^ self new profile: aBlock onClassCategory: classCategory
]

{ #category : #'public - profiling' }
S2Profiler class >> profile: aBlock onClassNamed: className [

	^ self new profile: aBlock onClassNamed: className
]

{ #category : #'public - profiling' }
S2Profiler class >> profile: aBlock onClasses: aClassCollection [
	"Execute aBlock while monitoring a list of classes "
	^ self new profile: aBlock onClasses: aClassCollection
]

{ #category : #'public - profiling' }
S2Profiler class >> profile: aBlock onClassesNamed: classNames [

	^ self new profile: aBlock onClassesNamed: classNames
]

{ #category : #'public - profiling' }
S2Profiler class >> profile: aBlock onMethod: aMethod [

	^ self new profile: aBlock onMethod: aMethod; yourself
]

{ #category : #'public - profiling' }
S2Profiler class >> profile: aBlock onMethods: aMethodCollection [

	^ self new profile: aBlock onMethods: aMethodCollection; yourself
]

{ #category : #'public - profiling' }
S2Profiler class >> profile: aBlock onPackage: aPackage [

	^ self new profile: aBlock onPackage: aPackage
]

{ #category : #'public - profiling' }
S2Profiler class >> profile: aBlock onPackageNamed: packageName [

	^ self new profile: aBlock onPackageNamed: packageName
]

{ #category : #'public - profiling' }
S2Profiler class >> profile: aBlock onPackages: packageCollection [

	^ self new profile: aBlock onPackages: packageCollection
]

{ #category : #'public - profiling' }
S2Profiler class >> profile: aBlock onPackagesMatching: regex [

	^ self new profile: aBlock onPackagesMatching: regex
]

{ #category : #'public - profiling' }
S2Profiler class >> profile: aBlock onPackagesMatchingExpresions: regexCollection [

	^ self new profile: aBlock onPackagesMatchingExpresions: regexCollection
]

{ #category : #'public - profiling' }
S2Profiler class >> profile: aBlock onPackagesNamed: packagesNames [

	^ self new profile: aBlock onPackagesNamed: packagesNames
]

{ #category : #'public - profiling' }
S2Profiler class >> profileString: codeAsString [
	"This method is invoked with source code as argument"

	| compiledBlock method classBindings classes |
	compiledBlock := self getCompiledBlockFromCodeAsString: codeAsString.
	method := compiledBlock method.
	classBindings := method literals
		select: [ :l | l class == GlobalVariable ].
	classes := (classBindings collect: #value) copyWithout: nil class.
	^ self profile: compiledBlock onClasses: classes
]

{ #category : #util }
S2Profiler class >> recompileMethodsWithSlots [
	Smalltalk allMethods do: [ :method |
			method hasSpySlot ifTrue: [ method recompile ] ].
	
]

{ #category : #util }
S2Profiler class >> remove [
	self clean
]

{ #category : #util }
S2Profiler class >> removeAllSlotsFromClasses [
	Smalltalk allClasses do: [ :cls | 
		(cls slots , cls class slots select: #isSpy) do: #uninstall ]
]

{ #category : #util }
S2Profiler class >> removeAllTemplates [
	Smalltalk allClasses do: [ :cls |
		cls methods , cls class methods do: [ :m | 
			m isSpy ifTrue: [ 
				m methodClass methodDict 
					at: m selector 
					put: m originalMethod ] ] ]
]

{ #category : #util }
S2Profiler class >> removeUsingResponsibility [
	Smalltalk allClasses do: [ :cls |
		((cls methods , cls class methods) 
			reject: [ :m | m responsibleSpy = nil ])
				do: [ :m | m responsibleSpy removeDependant: m ] ]
]

{ #category : #'public - running tests' }
S2Profiler class >> runTestsForClass: cls [

	^ self new runTestsForClass: cls
]

{ #category : #'public - running tests' }
S2Profiler class >> runTestsForClassCategory: aCategory [

	^ self new runTestsForClassCategory: aCategory
]

{ #category : #'public - running tests' }
S2Profiler class >> runTestsForClassNamed: clsName [

	^ self new runTestsForClassNamed: clsName
]

{ #category : #'public - running tests' }
S2Profiler class >> runTestsForClasses: classes [

	^ self new runTestsForClasses: classes
]

{ #category : #'public - running tests' }
S2Profiler class >> runTestsForClassesNamed: clsNames [

	^ self new runTestsForClassesNamed: clsNames
]

{ #category : #'public - running tests' }
S2Profiler class >> runTestsForMethods: methods [

	^ self new runTestsForMethods: methods
]

{ #category : #'public - running tests' }
S2Profiler class >> runTestsForPackage: package [
	self assert: [ package class == RPackage ] description: 'Provide a RPackage as argument'.
	^ self new runTestsForPackage: package
]

{ #category : #'public - running tests' }
S2Profiler class >> runTestsForPackageNamed: pacakgeName [

	^ self new runTestsForPackageNamed: pacakgeName
]

{ #category : #'public - running tests' }
S2Profiler class >> runTestsForPackages: packageCollection [

	^ self new runTestsForPackages: packageCollection
]

{ #category : #'public - running tests' }
S2Profiler class >> runTestsForPackagesMatching: regex [

	^ self new runTestsForPackagesMatching: regex
]

{ #category : #'public - running tests' }
S2Profiler class >> runTestsForPackagesMatchingExpresions: regexCollection [

	^ self new runTestsForPackagesMatchingExpresions: regexCollection
]

{ #category : #'public - running tests' }
S2Profiler class >> runTestsForPackagesNamed: pacakgeNames [

	^ self new runTestsForPackagesNamed: pacakgeNames
]

{ #category : #'public - comparison' }
S2Profiler class >> setForComparison: aProfile [
	LastProfile := aProfile 
]

{ #category : #util }
S2Profiler class >> shouldInstallOnClass: aClass [
	self assert: [ aClass theNonMetaClass == aClass ] description: 'Can only be called on non meta class'.
	
	^ (self isNotDangerous: aClass)
]

{ #category : #hooks }
S2Profiler class >> spyClassForClass [
	^ self spyClassForPackage spyClassForClass
]

{ #category : #hooks }
S2Profiler class >> spyClassForMethod [
	^ self spyClassForPackage spyClassForClass spyClassForMethod
]

{ #category : #hooks }
S2Profiler class >> spyClassForPackage [
	^ S2Package
]

{ #category : #'public - start profiling' }
S2Profiler class >> startOnClass: class [

	^ self new startOnClass: class
]

{ #category : #'public - start profiling' }
S2Profiler class >> startOnClassCategory: classCategory [

	^ self new startOnClassCategory: classCategory
]

{ #category : #'public - start profiling' }
S2Profiler class >> startOnClassNamed: className [

	^ self new startOnClassNamed: className
]

{ #category : #'public - start profiling' }
S2Profiler class >> startOnClasses: classes [

	^ self new startOnClasses: classes
]

{ #category : #'public - start profiling' }
S2Profiler class >> startOnClassesNamed: classNames [

	^ self new startOnClassesNamed: classNames
]

{ #category : #'public - start profiling' }
S2Profiler class >> startOnMethod: aMethod [

	^ self new startOnMethod: aMethod
]

{ #category : #'public - start profiling' }
S2Profiler class >> startOnMethods: aMethodCollection [

	^ self new startOnMethods: aMethodCollection
]

{ #category : #'public - start profiling' }
S2Profiler class >> startOnPackage: package [

	^ self new startOnPackage: package
]

{ #category : #'public - start profiling' }
S2Profiler class >> startOnPackageNamed: packageName [

	^ self new startOnPackageNamed: packageName
]

{ #category : #'public - start profiling' }
S2Profiler class >> startOnPackages: packageCollection [

	^ self new startOnPackages: packageCollection
]

{ #category : #'public - start profiling' }
S2Profiler class >> startOnPackagesMatching: regex [

	^ self new startOnPackagesMatching: regex
]

{ #category : #'public - start profiling' }
S2Profiler class >> startOnPackagesMatchingExpresions: regexCollection [

	^ self new startOnPackagesMatchingExpresions: regexCollection
]

{ #category : #'public - start profiling' }
S2Profiler class >> startOnPackagesNamed: packagesNames [

	^ self new startOnPackagesNamed: packagesNames
]

{ #category : #'private - method template' }
S2Profiler class >> templateCode [
	^ '^ #metaObject primitiveRun: #selector with: <1s> in: self  '
]

{ #category : #'private - method template' }
S2Profiler class >> templateMethodForNumberOfArguments: numberOfArguments [
	^ S2Profiler class>> (#(
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
S2Profiler class >> templateMethods [
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
S2Profiler class >> with0Arg [ 
^ #metaObject primitiveRun: #selector with: #() in: self  
]

{ #category : #'private - method template' }
S2Profiler class >> with10arg: v1 arg: v2 arg: v3 arg: v4 arg: v5 arg: v6 arg: v7 arg: v8 arg: v9 arg: v10 [ 
^ #metaObject primitiveRun: #selector with: {v1.v2.v3.v4.v5.v6.v7.v8.v9.v10} in: self  
]

{ #category : #'private - method template' }
S2Profiler class >> with11arg: v1 arg: v2 arg: v3 arg: v4 arg: v5 arg: v6 arg: v7 arg: v8 arg: v9 arg: v10 arg: v11 [ 
^ #metaObject primitiveRun: #selector with: {v1.v2.v3.v4.v5.v6.v7.v8.v9.v10.v11} in: self  
]

{ #category : #'private - method template' }
S2Profiler class >> with12arg: v1 arg: v2 arg: v3 arg: v4 arg: v5 arg: v6 arg: v7 arg: v8 arg: v9 arg: v10 arg: v11 arg: v12 [ 
^ #metaObject primitiveRun: #selector with: {v1.v2.v3.v4.v5.v6.v7.v8.v9.v10.v11.v12} in: self  
]

{ #category : #'private - method template' }
S2Profiler class >> with13arg: v1 arg: v2 arg: v3 arg: v4 arg: v5 arg: v6 arg: v7 arg: v8 arg: v9 arg: v10 arg: v11 arg: v12 arg: v13 [ 
^ #metaObject primitiveRun: #selector with: {v1.v2.v3.v4.v5.v6.v7.v8.v9.v10.v11.v12.v13} in: self  
]

{ #category : #'private - method template' }
S2Profiler class >> with14arg: v1 arg: v2 arg: v3 arg: v4 arg: v5 arg: v6 arg: v7 arg: v8 arg: v9 arg: v10 arg: v11 arg: v12 arg: v13 arg: v14 [ 
^ #metaObject primitiveRun: #selector with: {v1.v2.v3.v4.v5.v6.v7.v8.v9.v10.v11.v12.v13.v14} in: self  
]

{ #category : #'private - method template' }
S2Profiler class >> with15arg: v1 arg: v2 arg: v3 arg: v4 arg: v5 arg: v6 arg: v7 arg: v8 arg: v9 arg: v10 arg: v11 arg: v12 arg: v13 arg: v14 arg: v15 [ 
^ #metaObject primitiveRun: #selector with: {v1.v2.v3.v4.v5.v6.v7.v8.v9.v10.v11.v12.v13.v14.v15} in: self  
]

{ #category : #'private - method template' }
S2Profiler class >> with1arg: v1 [ 
^ #metaObject primitiveRun: #selector with: {v1} in: self  
]

{ #category : #'private - method template' }
S2Profiler class >> with2arg: v1 arg: v2 [ 
^ #metaObject primitiveRun: #selector with: {v1.v2} in: self  
]

{ #category : #'private - method template' }
S2Profiler class >> with3arg: v1 arg: v2 arg: v3 [ 
^ #metaObject primitiveRun: #selector with: {v1.v2.v3} in: self  
]

{ #category : #'private - method template' }
S2Profiler class >> with4arg: v1 arg: v2 arg: v3 arg: v4 [ 
^ #metaObject primitiveRun: #selector with: {v1.v2.v3.v4} in: self  
]

{ #category : #'private - method template' }
S2Profiler class >> with5arg: v1 arg: v2 arg: v3 arg: v4 arg: v5 [ 
^ #metaObject primitiveRun: #selector with: {v1.v2.v3.v4.v5} in: self  
]

{ #category : #'private - method template' }
S2Profiler class >> with6arg: v1 arg: v2 arg: v3 arg: v4 arg: v5 arg: v6 [ 
^ #metaObject primitiveRun: #selector with: {v1.v2.v3.v4.v5.v6} in: self  
]

{ #category : #'private - method template' }
S2Profiler class >> with7arg: v1 arg: v2 arg: v3 arg: v4 arg: v5 arg: v6 arg: v7 [ 
^ #metaObject primitiveRun: #selector with: {v1.v2.v3.v4.v5.v6.v7} in: self  
]

{ #category : #'private - method template' }
S2Profiler class >> with8arg: v1 arg: v2 arg: v3 arg: v4 arg: v5 arg: v6 arg: v7 arg: v8 [ 
^ #metaObject primitiveRun: #selector with: {v1.v2.v3.v4.v5.v6.v7.v8} in: self  
]

{ #category : #'private - method template' }
S2Profiler class >> with9arg: v1 arg: v2 arg: v3 arg: v4 arg: v5 arg: v6 arg: v7 arg: v8 arg: v9 [ 
^ #metaObject primitiveRun: #selector with: {v1.v2.v3.v4.v5.v6.v7.v8.v9} in: self  
]

{ #category : #'accessing - read only' }
S2Profiler >> >> aSymbol [
	"Fetching a class"
	
	"we are accessing a method defined in a metaclass"
	(aSymbol includes: $ ) ifTrue: [ ^ (self >> aSymbol substrings first asSymbol) metaclassSpy ].
	
	^ self classAt: aSymbol
]

{ #category : #'accessing - read only' }
S2Profiler >> >>> aPackageName [
	^ self packages detect: [:pak | pak packageName asString = aPackageName asString ]
]

{ #category : #'instrumentator - adding' }
S2Profiler >> addClassToProfile: class [
	(self instrumentator addClass: class) applyOn: self
]

{ #category : #'instrumentator - adding' }
S2Profiler >> addClassesToProfile: classes [
	(self instrumentator addClasses: classes) applyOn: self
]

{ #category : #'instrumentator - adding' }
S2Profiler >> addMethodToProfile: method [
	(self instrumentator addMethod: method) applyOn: self

]

{ #category : #'instrumentator - adding' }
S2Profiler >> addMethodsToProfile: methods [
	(self instrumentator addMethods: methods) applyOn: self
]

{ #category : #adding }
S2Profiler >> addPackage: aPackageSpy [
	self assert: [ aPackageSpy class == self class spyClassForPackage ].
	
	self packagesDictionary at: aPackageSpy packageName put: aPackageSpy.
	aPackageSpy profiler: self.
]

{ #category : #'instrumentator - adding' }
S2Profiler >> addPackageToProfile: package [
	(self instrumentator addPackage: package) applyOn: self
]

{ #category : #'instrumentator - adding' }
S2Profiler >> addPackagesToProfile: packageCollection [
	(self instrumentator addPackages: packageCollection) applyOn: self
]

{ #category : #hooks }
S2Profiler >> afterProfiling [ 
]

{ #category : #hooks }
S2Profiler >> afterUninstalling [
]

{ #category : #'accessing - read only' }
S2Profiler >> allClasses [
	| answer |
	allClassesCache ifNotNil: [ ^ allClassesCache ].
	answer := OrderedCollection new.
	self packages do: [:p | 
		answer addAll: p classes ].
	^ answer
]

{ #category : #'accessing - read only' }
S2Profiler >> allClassesAsDictionary [
	| answer |
	allClassesAsDictionaryCache ifNotNil: [ ^ allClassesAsDictionaryCache ].
	answer := IdentityDictionary new.
	self packages do: [:p | p classes do: [:c | answer at: c className put: c]].
	^ answer
]

{ #category : #'accessing - read only' }
S2Profiler >> allClassesSuchThat: aBlock [
	^ self allClasses select: aBlock
]

{ #category : #'accessing - read only' }
S2Profiler >> allMethods [
	"Return the list of all the methods"
	
	| methods |
	allMethodsCache ifNotNil: [ ^ allMethodsCache ].
	
	methods := OrderedCollection new.
	self packages do: [:p | 
		methods addAll: p allMethods ].
	^ methods 
]

{ #category : #'accessing - read only' }
S2Profiler >> allNonAbstractMethods [
	"Return the list of non abstract methods"
	
	allNonAbstractMethodsCache ifNotNil: [ ^ allNonAbstractMethodsCache ].
	^ allNonAbstractMethodsCache := self allMethods reject: #isAbstract
]

{ #category : #'accessing - read only' }
S2Profiler >> allNonMetaClasses [
	^ self allClasses reject: #isMeta
]

{ #category : #hooks }
S2Profiler >> beforeInstalling [
	
]

{ #category : #hooks }
S2Profiler >> beforeProfiling [ 
	
]

{ #category : #'build metamodel' }
S2Profiler >> buildSpyClass: className onPackage: spyPackage [
	
	| cls |
	cls := self class spyClassForClass new
		className: className asSymbol;
		packageSpy: spyPackage;
		yourself.
	spyPackage classAt: className asSymbol put: cls.
	^ cls
]

{ #category : #'build metamodel' }
S2Profiler >> buildSpyPackage: packageName [

	^ self class spyClassForPackage new
		packageName: packageName;
		profiler: self;
		yourself
]

{ #category : #'accessing - read only' }
S2Profiler >> classAt: aSymbol [
	^ self allClassesAsDictionary at: aSymbol ifAbsent: [ self error: 'Class ', aSymbol, ' not found']
]

{ #category : #'accessing - read only' }
S2Profiler >> classAt: aSymbol ifNone: aBlock [
	^ self allClassesAsDictionary at: aSymbol ifAbsent: aBlock
	
]

{ #category : #plugins }
S2Profiler >> classPlugins [

	^ classPlugins
]

{ #category : #actions }
S2Profiler >> clean [
	^ self class clean
]

{ #category : #plugins }
S2Profiler >> collectPragmas: keyword [
	^ (PragmaCollector
		filter:
			[ :prg | prg selector = keyword and: [ self isKindOf: prg methodClass ] ])
		reset;
		collected
]

{ #category : #'private - running tests' }
S2Profiler >> collectTests [

	| tests testClasses |
	tests := OrderedCollection new.
	testClasses := ((self allClasses select: #isTestClass) reject: #isAbstract) collect: #theClass.
	testClasses do: [ :cls |
		cls allTestSelectors do: [ :selector | tests add: (cls selector: selector) ] ].
	^ tests
]

{ #category : #comparison }
S2Profiler >> commonMethods [
	^ self allMethods select: #isNotNewMethod
]

{ #category : #caches }
S2Profiler >> computeCaches [
	allMethodsCache := self allMethods.
	allClassesAsDictionaryCache := self allClassesAsDictionary.
	allClassesCache := self allClasses.
]

{ #category : #'creating - metamodel' }
S2Profiler >> createSpyClass: class [

	| spyPackage spyClass |
	(class getSpy: self) ifNotNil: [ :spyCls | ^ spyCls ].
	spyPackage := self createSpy: class package.
	spyClass := self class spyClassForClass new
		className: class name asSymbol;
		packageSpy: spyPackage;
		yourself.
	spyPackage 
		classAt: class name asSymbol
		put: spyClass.
	self createSpy: class class.
	^ spyClass
]

{ #category : #'creating - metamodel' }
S2Profiler >> createSpyMetaclass: metaclass [
	| metaclassSpy baseclass |
	(metaclass getSpy: self) ifNotNil: [ :spy | ^ spy ].
	baseclass := metaclass instanceSide createSpy: self.
	metaclassSpy := self class spyClassForClass new
		className: metaclass name asSymbol;
		packageSpy: baseclass packageSpy;
		yourself.
	baseclass metaclassSpy: metaclassSpy.
	^ metaclassSpy
]

{ #category : #'creating - metamodel' }
S2Profiler >> createSpyMethod: method [

	|spyMethod spyClass spyPackage | 
	(method getSpy: self) ifNotNil: [ :m | ^ m ].
	spyClass := (method methodClass createSpy: self).
	spyPackage := ((method package ifNil: [method methodClass package]) createSpy: self).
	spyMethod := self class spyClassForMethod new 
							originalMethod: method; 
							selector: method selector;
							classSpy: spyClass;
							packageSpy: spyPackage;
							yourself.
	spyClass localMethodAt: method selector put: spyMethod.
	spyPackage addMethod: spyMethod.
	^ spyMethod
]

{ #category : #'creating - metamodel' }
S2Profiler >> createSpyPackage: package [

	(package getSpy: self) ifNotNil: [ :spyPak | ^ spyPak ].
	^ packages 
		at: package packageName
		put: (self buildSpyPackage: package packageName)
]

{ #category : #'accessing - computed' }
S2Profiler >> currentMethod [

	^ self spyContext spyMethod
]

{ #category : #'accessing - computed' }
S2Profiler >> currentReceiver [

	^ self spyContext receiver
]

{ #category : #'accessing - computed' }
S2Profiler >> currentRunningTest [
	|context|
	context := self spyContext.
	[ context = nil ] whileFalse: [ 
		context spyMethod isTest ifTrue: [ ^ context spyMethod ].
		context := context sender.
	].
	^ nil
]

{ #category : #'accessing - metamodel' }
S2Profiler >> getSpyClass: class [

	^ self classAt: class name ifNone: [ nil ]
]

{ #category : #'accessing - metamodel' }
S2Profiler >> getSpyMetaclass: class [
	^ (class instanceSide getSpy: self) ifNotNil: #metaclassSpy
]

{ #category : #'accessing - metamodel' }
S2Profiler >> getSpyMethod: method [

	^ (method methodClass getSpy: self)ifNotNil: [ :cls | cls localMethodAt: method selector ifAbsent: [ nil ] ]
]

{ #category : #'accessing - metamodel' }
S2Profiler >> getSpyPackage: package [

	^ packages at: package name ifAbsent: [ nil ]
]

{ #category : #testing }
S2Profiler >> hasStarted [
	^ self instrumentator isVoidInstrumentator not
]

{ #category : #initialization }
S2Profiler >> initialize [ 
	super initialize.
	packages := Dictionary new.
	methodPlugins := (self plugins: #S2MethodPlugin) sortedAs: #priority.
	classPlugins := (self plugins: #S2ClassPlugin) sortedAs: #priority.
	profilerPlugins := (self plugins: #S2ProfilerPlugin) sortedAs: #priority.
	S2Instrumentator initializeProfiler: self.
]

{ #category : #accessing }
S2Profiler >> instrumentator [
	^ instrumentator
]

{ #category : #private }
S2Profiler >> instrumentator: object [
	instrumentator := object
]

{ #category : #caches }
S2Profiler >> invalidateCaches [
	allMethodsCache := nil.
	allClassesAsDictionaryCache := nil.
	allClassesCache := nil
]

{ #category : #comparison }
S2Profiler >> isReadyForComparison [
	"Return true if there is a profile for comparison"

	^ self class isReadyForComparison
]

{ #category : #comparison }
S2Profiler >> lastProfile [
	"Return the profile which has been set for comparison. Return nil if no profile has been set"
	^ self class lastProfile
]

{ #category : #plugins }
S2Profiler >> methodPlugins [

	^ methodPlugins
]

{ #category : #'accessing - read only' }
S2Profiler >> numberOfClasses [
	^ self allClasses size
]

{ #category : #'accessing - read only' }
S2Profiler >> numberOfMethods [
	^ self allMethods size
]

{ #category : #'accessing - read only' }
S2Profiler >> numberOfNonAbstractMethods [
	"Return the number of non abstract methods, including the one of the metaclass "

	^ self allNonAbstractMethods size
]

{ #category : #utils }
S2Profiler >> packageForName: name [
	^ S2Gatherer uniqueInstance gather packageForName: name
]

{ #category : #accessing }
S2Profiler >> packages [
	^ packages values
]

{ #category : #adding }
S2Profiler >> packagesDictionary [

	^ packages
]

{ #category : #plugins }
S2Profiler >> plugins: keyword [

	^ (self collectPragmas: keyword) 
		collect: [ :prg |
			prg method valueWithReceiver: self arguments: #() ]
]

{ #category : #profiling }
S2Profiler >> profile: aBlock onClass: aClass [
	[ 	self startOnClass: aClass.
		aBlock value ] ensure: [ self stop ]
]

{ #category : #profiling }
S2Profiler >> profile: aBlock onClassCategory: classCategory [
	[ 	self startOnClassCategory: classCategory.
		aBlock value ] ensure: [ self stop ]
]

{ #category : #profiling }
S2Profiler >> profile: aBlock onClassNamed: className [
	[ 	self startOnClassNamed: className.
		aBlock value ] ensure: [ self stop ]
]

{ #category : #profiling }
S2Profiler >> profile: aBlock onClasses: aClassCollection [
	[ 	self startOnClasses: aClassCollection.
		aBlock value ] ensure: [ self stop ]
]

{ #category : #profiling }
S2Profiler >> profile: aBlock onClassesNamed: classNames [
	[ 	self startOnClassesNamed: classNames.
		aBlock value ] ensure: [ self stop ]
]

{ #category : #profiling }
S2Profiler >> profile: aBlock onMethod: aMethod [
	[ 	self startOnMethod: aMethod.
		aBlock value ] ensure: [ self stop ]
]

{ #category : #profiling }
S2Profiler >> profile: aBlock onMethods: aMethodCollection [
	[ 	self startOnMethods: aMethodCollection.
		aBlock value ] ensure: [ self stop ]
]

{ #category : #profiling }
S2Profiler >> profile: aBlock onPackage: aPackage [
	[ 	self startOnPackage: aPackage.
		aBlock value ] ensure: [ self stop ]
]

{ #category : #profiling }
S2Profiler >> profile: aBlock onPackageNamed: packageName [
	[ 	self startOnPackageNamed: packageName.
		aBlock value ] ensure: [ self stop ]
]

{ #category : #profiling }
S2Profiler >> profile: aBlock onPackages: packageCollection [
	[ 	self startOnPackages: packageCollection.
		aBlock value ] ensure: [ self stop ]
]

{ #category : #profiling }
S2Profiler >> profile: aBlock onPackagesMatching: regex [
	[ 	self startOnPackagesMatching: regex.
		aBlock value ] ensure: [ self stop ]
]

{ #category : #profiling }
S2Profiler >> profile: aBlock onPackagesMatchingExpresions: regexCollection [
	^ self profile: aBlock onPackagesMatchingExpressions: regexCollection
]

{ #category : #profiling }
S2Profiler >> profile: aBlock onPackagesMatchingExpressions: regexCollection [
	[ 	self startOnPackagesMatchingExpressions: regexCollection.
		aBlock value ] ensure: [ self stop ]
]

{ #category : #profiling }
S2Profiler >> profile: aBlock onPackagesNamed: packagesNames [
	[ 	self startOnPackagesNamed: packagesNames.
		aBlock value ] ensure: [ self stop ]
]

{ #category : #accessing }
S2Profiler >> profiler [

	^ self
]

{ #category : #plugins }
S2Profiler >> profilerPlugins [

	^ profilerPlugins
]

{ #category : #comparison }
S2Profiler >> profilings [
	^ self class profilingOf: self class
]

{ #category : #actions }
S2Profiler >> remove [
	^ self clean
]

{ #category : #'instrumentator - removing' }
S2Profiler >> removeClassFromProfile: class [
	(self instrumentator removeClass: class) applyOn: self
]

{ #category : #'instrumentator - removing' }
S2Profiler >> removeClassesFromProfile: classCollection [
	(self instrumentator removeClasses: classCollection) applyOn: self
]

{ #category : #'instrumentator - removing' }
S2Profiler >> removeMethodFromProfile: method [
	(self instrumentator removeMethod: method) applyOn: self
]

{ #category : #'instrumentator - removing' }
S2Profiler >> removeMethodsFromProfile: methods [
	(self instrumentator removeMethods: methods) applyOn: self
]

{ #category : #'instrumentator - removing' }
S2Profiler >> removePackageFromProfile: package [
	(self instrumentator removePackage: package) applyOn: self
]

{ #category : #'instrumentator - removing' }
S2Profiler >> removePackagesFromProfile: packageCollection [
	(self instrumentator removePackages: packageCollection) applyOn: self
]

{ #category : #'private - running tests' }
S2Profiler >> runTest: test withResults: results [
	"This method simply run the test method using the test result.
	This method may be overriden in subclasses in case one need more logic here"
	test run: results
]

{ #category : #'running tests' }
S2Profiler >> runTestsForClass: cls [

	^ self profile: [ self runUnitTests ] onClass: cls
]

{ #category : #'running tests' }
S2Profiler >> runTestsForClassCategory: category [

	^ self profile: [ self runUnitTests ] onClassCategory: category
]

{ #category : #'running tests' }
S2Profiler >> runTestsForClassNamed: clsName [

	^ self profile: [ self runUnitTests ] onClassNamed: clsName
]

{ #category : #'running tests' }
S2Profiler >> runTestsForClasses: classes [

	^ self profile: [ self runUnitTests ] onClasses: classes
]

{ #category : #'running tests' }
S2Profiler >> runTestsForClassesNamed: clsNames [

	^ self profile: [ self runUnitTests ] onClassesNamed: clsNames
]

{ #category : #'running tests' }
S2Profiler >> runTestsForMethods: methods [

	^ self profile: [ self runUnitTests ] onMethods: methods
]

{ #category : #'running tests' }
S2Profiler >> runTestsForPackage: package [
	self assert: [ package class == RPackage ] description: 'Provide a RPackage as argument'.
	^ self profile: [ self runUnitTests ] onPackage: package
]

{ #category : #'running tests' }
S2Profiler >> runTestsForPackageNamed: pacakgeName [

	^ self profile: [ self runUnitTests ] onPackageNamed: pacakgeName
]

{ #category : #'running tests' }
S2Profiler >> runTestsForPackages: packageCollection [

	^ self profile: [ self runUnitTests ] onPackages: packageCollection
]

{ #category : #'running tests' }
S2Profiler >> runTestsForPackagesMatching: regex [

	^ self profile: [ self runUnitTests ] onPackagesMatching: regex
]

{ #category : #'running tests' }
S2Profiler >> runTestsForPackagesMatchingExpresions: regexCollection [

	^ self runTestsForPackagesMatchingExpressions: regexCollection
]

{ #category : #'running tests' }
S2Profiler >> runTestsForPackagesMatchingExpressions: regexCollection [

	^ self profile: [ self runUnitTests ] onPackagesMatchingExpressions: regexCollection
]

{ #category : #'running tests' }
S2Profiler >> runTestsForPackagesNamed: pacakgeNames [

	^ self profile: [ self runUnitTests ] onPackagesNamed: pacakgeNames
]

{ #category : #'private - running tests' }
S2Profiler >> runUnitTests [
	| ind tests results |
	ind := 0.
	results := TestResult new.
	tests := self collectTests.
	'Running tests'
		displayProgressFrom: 0
		to: tests size
		during:
			[ :bar | 
			tests
				do:
					[ :test | 
					self runTest: test withResults: results.
					ind := ind + 1.
					bar value: ind ] ].
	unitTestResult := results
]

{ #category : #comparison }
S2Profiler >> setForComparison [
	"Keep a reference of the profiler. Useful for comparing"
	self class setForComparison: self
]

{ #category : #'accessing - computed' }
S2Profiler >> spyContext [

	^ S2Context top
]

{ #category : #'accessing - computed' }
S2Profiler >> spySender [

	^ self spyContext sender ifNotNil: [ :frame | frame spyMethod ]
]

{ #category : #'start-stop profiling' }
S2Profiler >> startOnClass: class [
	(S2Instrumentator onClass: class) applyOn: self
]

{ #category : #'start-stop profiling' }
S2Profiler >> startOnClassCategory: classCategory [
	(S2Instrumentator onClassCategory: classCategory) applyOn: self
]

{ #category : #'start-stop profiling' }
S2Profiler >> startOnClassNamed: className [
	(S2Instrumentator onClassNamed: className) applyOn: self
]

{ #category : #'start-stop profiling' }
S2Profiler >> startOnClasses: classes [
	(S2Instrumentator onClasses: classes) applyOn: self.
]

{ #category : #'start-stop profiling' }
S2Profiler >> startOnClassesNamed: classNames [
	(S2Instrumentator onClassesNamed: classNames) applyOn: self
]

{ #category : #'start-stop profiling' }
S2Profiler >> startOnMethod: aMethod [
	(S2Instrumentator onMethod: aMethod) applyOn: self
]

{ #category : #'start-stop profiling' }
S2Profiler >> startOnMethods: aMethodCollection [
	(S2Instrumentator onMethods: aMethodCollection) applyOn: self.
]

{ #category : #'start-stop profiling' }
S2Profiler >> startOnPackage: package [
	(S2Instrumentator onPackage: package) applyOn: self
]

{ #category : #'start-stop profiling' }
S2Profiler >> startOnPackageNamed: packageName [
	(S2Instrumentator onPackageNamed: packageName) applyOn: self
]

{ #category : #'start-stop profiling' }
S2Profiler >> startOnPackages: packageCollection [
	(S2Instrumentator onPackages: packageCollection) applyOn: self.
]

{ #category : #'start-stop profiling' }
S2Profiler >> startOnPackagesMatching: regex [
	(S2Instrumentator onPackagesMatching: regex) applyOn: self.
]

{ #category : #'start-stop profiling' }
S2Profiler >> startOnPackagesMatchingExpresions: regexCollection [
	self startOnPackagesMatchingExpressions: regexCollection
]

{ #category : #'start-stop profiling' }
S2Profiler >> startOnPackagesMatchingExpressions: regexCollection [
	(S2Instrumentator onPackagesMatchingExpressions: regexCollection) applyOn: self.
]

{ #category : #'start-stop profiling' }
S2Profiler >> startOnPackagesNamed: packagesNames [
	(S2Instrumentator onPackagesNamed: packagesNames) applyOn: self.
]

{ #category : #'start-stop profiling' }
S2Profiler >> stop [
	S2VoidInstrumentator new applyOn: self
]

{ #category : #accessing }
S2Profiler >> unitTestResult [
	^ unitTestResult
]

{ #category : #accessing }
S2Profiler >> unitTestResult: testResult [
	unitTestResult := testResult
]
