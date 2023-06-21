Extension { #name : #ClassDescription }

{ #category : #'*Spy2-Core' }
ClassDescription >> allSlotsSuperclasses [
	"Answer the set of slots used by the receiver, all superclasses, and all subclasses"
	| aList |
	aList := OrderedCollection new.
	self withAllSuperclasses do:
		[:cls | aList addAll: cls slots].
	^ aList asSet
]

{ #category : #'*Spy2-Core' }
ClassDescription >> allSpySlotsSuperclasses [
	"Answer the set of slots used by the receiver, all superclasses, and all subclasses"
	| aList |
	aList := OrderedCollection new.
	self withAllSuperclasses do:
		[:cls | aList addAll: (cls slots select: #isSpy)].
	^ aList asSet
]

{ #category : #'*Spy2-Core' }
ClassDescription >> asSpyRingDefinition [
	^ self asRingDefinition
]

{ #category : #'*Spy2-Core' }
ClassDescription >> classWithMetaclass [

	^ { 
		  self instanceSide.
		  self classSide }
]
