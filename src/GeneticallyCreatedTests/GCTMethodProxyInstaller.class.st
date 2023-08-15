Class {
	#name : #GCTMethodProxyInstaller,
	#superclass : #Object,
	#instVars : [
		'targetClass',
		'proxyClass',
		'proxies'
	],
	#category : #'GeneticallyCreatedTests-Profiling-Core'
}

{ #category : #'as yet unclassified' }
GCTMethodProxyInstaller >> computeProxies [
	^ (targetClass methods, targetClass class methods) select: [ :p | p isKindOf: GCTMethodProxy ]
]

{ #category : #'as yet unclassified' }
GCTMethodProxyInstaller >> doInstallOn: aClass [
	| d |
	d := aClass methodDictionary.
	aClass selectors do: [ :k |
		d at: k put: (proxyClass new originalMethod: (aClass >> k)) ]
]

{ #category : #initialization }
GCTMethodProxyInstaller >> initialize [
	super initialize.
	self proxyClass: GCTMethodProxyLog
]

{ #category : #'as yet unclassified' }
GCTMethodProxyInstaller >> install [
	self uninstall.
	self doInstallOn: targetClass.
	self doInstallOn: targetClass class.
	proxies := self computeProxies
]

{ #category : #accessing }
GCTMethodProxyInstaller >> proxyClass [

	^ proxyClass
]

{ #category : #accessing }
GCTMethodProxyInstaller >> proxyClass: aClass [
	self assert: [ aClass isBehavior ].
	proxyClass := aClass
]

{ #category : #running }
GCTMethodProxyInstaller >> run: aBlock [
	self install.
	[ aBlock value ] ensure: [ self uninstall ]
]

{ #category : #accessing }
GCTMethodProxyInstaller >> targetClass [

	^ targetClass
]

{ #category : #accessing }
GCTMethodProxyInstaller >> targetClass: aClass [
	self assert: [ aClass isBehavior ].
	targetClass := aClass
]

{ #category : #'as yet unclassified' }
GCTMethodProxyInstaller >> uninstall [
	self uninstallOn: targetClass.
	self uninstallOn: targetClass class.
]

{ #category : #'as yet unclassified' }
GCTMethodProxyInstaller >> uninstallOn: aClass [
	aClass selectors copy do: [ :k |
		| cm |
		cm := aClass >> k.
		(cm isKindOf: GCTMethodProxy)
			ifTrue: [ aClass methodDictionary at: k put: cm originalMethod ] ]
]
