Class {
	#name : #GCTMethodProxyInstallerCoverage,
	#superclass : #GCTMethodProxyInstaller,
	#category : 'GeneticallyCreatedTests-Profiling-Core'
}

{ #category : #coverage }
GCTMethodProxyInstallerCoverage >> coverage [
	^ ((proxies select: #isMarked) size / proxies size) asFloat
]

{ #category : #initialization }
GCTMethodProxyInstallerCoverage >> initialize [
	super initialize.
	self proxyClass: GCTMethodProxyCoverage
]
