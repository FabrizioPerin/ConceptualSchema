Class {
	#name : #MJCSImportConceptualSchemaFromPlazma,
	#superclass : #MJCSImportConceptualSchema,
	#category : #'ConceptualSchema-experiment'
}

{ #category : #'as yet unclassified' }
MJCSImportConceptualSchemaFromPlazma class >> on: aTargetModel [
	^ self new targetModel: aTargetModel.
]

{ #category : #accessing }
MJCSImportConceptualSchemaFromPlazma >> createLonelyConcepts: aSetOfClasses [
	| res |
	
	aSetOfClasses do: [:class |
		self resultsDictionary 
			at: class name 
			ifPresent: [:value | value add: class]
			ifAbsent: [self resultsDictionary at: class name put: (Set with: class) ] ]
	
	
]

{ #category : #accessing }
MJCSImportConceptualSchemaFromPlazma >> importCCOfPlazsma [
	| role |
	self threshold: 10.
	role :=self targetModel allRoles first.
	self importFromAClassGroup: (role associatedClass collect: [:each | each implementor]) asMooseGroup.
	
]

{ #category : #accessing }
MJCSImportConceptualSchemaFromPlazma >> importCCOfPlazsmaWithoutLonelyClasses [
	| role |
	self threshold: 10.
	role :=self targetModel allRoles first.
	self importFromAClassGroupWithoutLonelyClasses: (role associatedClass collect: [:each | each implementor]) asMooseGroup.
	
]

{ #category : #accessing }
MJCSImportConceptualSchemaFromPlazma >> importDomainModel [
	^(MJCSImportDomainModel on: self sourceModel) populateConceptualScemaWithDomainModel
]

{ #category : #accessing }
MJCSImportConceptualSchemaFromPlazma >> importFromAClassGroup: aMooseClassGroup [
	| concepts called |

	self LCSSOn: aMooseClassGroup.
	self createLonelyConcepts: (aMooseClassGroup asSet difference: self resultsDictionary values flatten asSet).
	concepts := self createConceptsFrom: self resultsDictionary.	
	self populateSourceModelWith: concepts.
]

{ #category : #accessing }
MJCSImportConceptualSchemaFromPlazma >> importFromAClassGroupWithoutLonelyClasses: aMooseClassGroup [
	| concepts called |

	self LCSSOn: aMooseClassGroup.
	concepts := self createConceptsFrom: self resultsDictionary.
	self populateSourceModelWith: concepts.
]
