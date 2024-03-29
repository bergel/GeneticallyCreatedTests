Class {
	#name : #GCTMethodProxyInstallerType,
	#superclass : #GCTMethodProxyInstaller,
	#category : #'GeneticallyCreatedTests-Profiling-Core'
}

{ #category : #'as yet unclassified' }
GCTMethodProxyInstallerType >> allClassesUsedAsArguments [
	^ proxies flatCollect: #argTypes as: Set
"	^ ((self methods select: [ :m | m signature notNil ]) flatCollect: [ :m | m signature third ]) asSet asArray collect: [ :clsName | Smalltalk at: clsName ]"
]

{ #category : #'as yet unclassified' }
GCTMethodProxyInstallerType >> allMarkedMethods [
	^ proxies select: #isMarked thenCollect: #selector
]

{ #category : #coverage }
GCTMethodProxyInstallerType >> coverage [
	^ ((proxies select: #isMarked) size / proxies size) asFloat
]

{ #category : #initialization }
GCTMethodProxyInstallerType >> initialize [
	super initialize.
	self proxyClass: GCTMethodProxyType
]

{ #category : #'as yet unclassified' }
GCTMethodProxyInstallerType >> signatureOf: selector [
	^ proxies detect: [ :p | p selector == selector ] ifNone: [ nil ]
]
