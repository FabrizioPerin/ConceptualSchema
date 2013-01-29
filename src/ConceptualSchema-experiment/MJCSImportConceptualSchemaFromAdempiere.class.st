Class {
	#name : #MJCSImportConceptualSchemaFromAdempiere,
	#superclass : #MJCSImportConceptualSchema,
	#category : #'ConceptualSchema-experiment'
}

{ #category : #'as yet unclassified' }
MJCSImportConceptualSchemaFromAdempiere class >> run [
	| target source |
	
	source := MooseModel root first.
	target :=  ConceptualSchema new name: 'CCAdempiere'.
	
	^((self on: target) sourceModel: source) importCCOfAdempiere 
]

{ #category : #accessing }
MJCSImportConceptualSchemaFromAdempiere >> createLonelyConcepts: aSetOfClasses [
	| res |
	
	aSetOfClasses do: [:class |
		self resultsDictionary 
			at: class name 
			ifPresent: [:value | value add: class]
			ifAbsent: [self resultsDictionary at: class name put: (Set with: class) ] ]
	
	
]

{ #category : #'as yet unclassified' }
MJCSImportConceptualSchemaFromAdempiere >> findModelClassesFrom: aCollectionOfNames [
	| result |
	
	result := OrderedCollection new.

	aCollectionOfNames do: [:aClassName |
		result addAll: (self sourceModel allClasses select: [:class | 
			class mooseName asString = aClassName ] ) ].

	^ result
]

{ #category : #'as yet unclassified' }
MJCSImportConceptualSchemaFromAdempiere >> importActiveRecordClassListFromFile: aFileName [
	| ln stream classNames |

	stream := StandardFileStream fileNamed: aFileName.

	classNames := OrderedCollection new.	
	[(ln := stream nextLine) isNil] whileFalse: [ 
		classNames add: ln].

	^classNames
]

{ #category : #'as yet unclassified' }
MJCSImportConceptualSchemaFromAdempiere >> importActiveRecordClassListFromactiveRecordsTxt [

	^self findModelClassesFrom: (self importActiveRecordClassListFromFile:  '/Users/fabrizioperin/Development/Pharo/Projects/CollaborazioneArcelli/activeRecords.txt')

]

{ #category : #accessing }
MJCSImportConceptualSchemaFromAdempiere >> importCCOfAdempiere [
	self threshold: 5.
	self importFromAClassGroup: self importActiveRecordClassListFromactiveRecordsTxt.
	(MJCSImportDomainModel on: self targetModel ) populateConceptualScemaWithDomainModel
]

{ #category : #accessing }
MJCSImportConceptualSchemaFromAdempiere >> importFromAClassGroup: aMooseClassGroup [
	| concepts called |

	self LCSSOn: aMooseClassGroup.
	self createLonelyConcepts: (aMooseClassGroup asSet difference: self resultsDictionary values flatten asSet).
	self halt.
	concepts := self createConceptsFrom: self resultsDictionary.
	self populateSourceModelWith: concepts.
]
