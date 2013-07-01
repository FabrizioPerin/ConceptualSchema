Class {
	#name : #MJCSImportConceptualSchema,
	#superclass : #Object,
	#instVars : [
		'sourceModel',
		'targetModel',
		'threshold',
		'resultsDictionary'
	],
	#category : #'ConceptualSchema-Importer'
}

{ #category : #'as yet unclassified' }
MJCSImportConceptualSchema class >> on: aTargetModel [
	^ self new targetModel: aTargetModel.
]

{ #category : #'as yet unclassified' }
MJCSImportConceptualSchema >> LCSSOn: aCollectionOfNames [

	| result aStream lcssAlgo |
	
	aStream := MultiByteFileStream forceNewFileNamed:  'output.csv'.
	MJLongestCommonSubString writeCVSEntryHeaderOn: aStream.

	MooseCustomTask 
		runWithProgress:  [ :bar | 
			(1 to: aCollectionOfNames size)
				do: [ :firstIndex | 
					((firstIndex + 1) to: aCollectionOfNames size)
						do: [ :secondIndex |
							| res |
							res := self computeLCSSOf: (aCollectionOfNames at: firstIndex) name and: (aCollectionOfNames at: secondIndex) name andPrintFilteredResultsOn: aStream.
							res isNil ifFalse: [
								self resultsDictionary 
									at: res
										ifPresent: [:value | 
											value add: (aCollectionOfNames at: firstIndex).
											value add:  (aCollectionOfNames at: secondIndex)]
										ifAbsent: [
											self resultsDictionary 
												at: res
												put: (Set with: (aCollectionOfNames at: firstIndex) with:  (aCollectionOfNames at: secondIndex)) ] ].
							bar increment ] ] ]
		description:  'Computing LCSS among all the elements in the collection' 
		length: ((aCollectionOfNames size * aCollectionOfNames size) / 2) asInteger.
	
	aStream close 
]

{ #category : #'as yet unclassified' }
MJCSImportConceptualSchema >> applyFilterOn: aString [
	| res |
	res := aString removePrefix: '_'.
	res := res removeSuffix: '_'.
	res := res replaceAllRegex: '^.*\_.*\_' with: ''.
	
	^res
]

{ #category : #'as yet unclassified' }
MJCSImportConceptualSchema >> computeLCSSOf: aString and: anotherString andPrintFilteredResultsOn: aStream [
	| lcssAlgo |

	lcssAlgo := MJLongestCommonSubString 
					of: aString
					and: anotherString.
	lcssAlgo computeLCSS.
	(lcssAlgo result size > 0)
			ifTrue: [
				| res |
				res := lcssAlgo result first. 
				( ( ( lcssAlgo firstSequence size * ( 0.55 ) ) asInteger < res size ) 
					and: [( ( lcssAlgo secondSequence size * ( 0.55 ) ) asInteger < res size ) ] )
						ifTrue: [
							"(res beginsWith: '_' ) ifTrue: [self halt]. "
							res := self applyFilterOn: res.
							( ( ( lcssAlgo firstSequence size * ( 0.55 ) ) asInteger < res size ) 
								and: [( ( lcssAlgo secondSequence size * ( 0.55 ) ) asInteger < res size ) ] )
									ifTrue: [
										lcssAlgo writeResultAsCVSEntryOn: aStream.
										^ res ] ] ]. 
	^ nil
						
]

{ #category : #experiments }
MJCSImportConceptualSchema >> createConceptsFrom: aDictionary [
	| concepts |

	concepts := OrderedCollection new.
	
	aDictionary keysAndValuesDo: [:key :value |
		| tables concept |
		tables := Set new.
		value do: [:each | tables addAll: each mappedRelationalEntities ].
		tables size > 0 ifTrue: [
			concept := ConceptualSchemaConcept named: key asString containing: value.
			concept addMappedEntitiesIn: tables.
			concepts add: concept ] ].

	^ concepts
]

{ #category : #'as yet unclassified' }
MJCSImportConceptualSchema >> findModelClassesFrom: aCollectionOfNames [
	| result |
	
	result := OrderedCollection new.

	aCollectionOfNames do: [:aClassName |
		result addAll: (self targetModel allClasses select: [:class | 
			class mooseName = aClassName ] ) ].

	^ result
]

{ #category : #'as yet unclassified' }
MJCSImportConceptualSchema >> importActiveRecordClassListFromFile: aFileName [
	| ln stream classNames |

	stream := StandardFileStream fileNamed: aFileName.

	classNames := Set new.	
	[(ln := stream nextLine) isNil] whileFalse: [ 
		classNames add: ln].
	
	^classNames
]

{ #category : #experiments }
MJCSImportConceptualSchema >> importFrom: aFileName [
	| classList concepts |

	classList := self findModelClassesFrom: (self importActiveRecordClassListFromFile: aFileName).
	self LCSSOn: classList.
	self resultsDictionary.
	concepts := self createConceptsFrom: self resultsDictionary.
	self populateSourceModelWith: concepts.
]

{ #category : #experiments }
MJCSImportConceptualSchema >> importFromAClassGroup: aMooseClassGroup [
	| concepts called excludedClasses |

	self LCSSOn: aMooseClassGroup.
	
	
	concepts := self createConceptsFrom: self resultsDictionary.
	excludedClasses := (concepts flatCollect: [:concept | concept mappedEntities ]) select: [:each | each isMemberOf: FAMIXClass ].
	concepts addAll: (self createLonelyConcepts: (aMooseClassGroup asSet difference: excludedClasses asSet)).
	self halt.
	self populateSourceModelWith: concepts.
]

{ #category : #experiments }
MJCSImportConceptualSchema >> importFromActiveRecord [
	
	self importFromFile: '/Users/fabrizioperin/Development/Pharo/Projects/CollaborazioneArcelli/activeRecords.txt'.
	
]

{ #category : #experiments }
MJCSImportConceptualSchema >> importFromActiveRecordNew [
	
	self importFromFile: '/Users/fabrizioperin/Development/Pharo/Projects/CollaborazioneArcelli/Sources/ActiveRecordsPerPlazma.txt'.
	
]

{ #category : #experiments }
MJCSImportConceptualSchema >> importFromFile [
	self threshold: 5.
	self LCSSOn: self importActiveRecordClassListFromactiveRecordsTxt.
	self resultsDictionary.
	^ self createConceptsFrom: self resultsDictionary.
]

{ #category : #experiments }
MJCSImportConceptualSchema >> importFromFile: called [

	self importFromAClassGroup: (self findModelClassesFrom: (self importActiveRecordClassListFromFile: called)).
]

{ #category : #'initialize-release' }
MJCSImportConceptualSchema >> initialize [ 

	resultsDictionary := Dictionary new.
	self threshold: 4.
	self sourceModel: (ConceptualSchema new name: 'Conceptual schema').
	
	^self 
]

{ #category : #'as yet unclassified' }
MJCSImportConceptualSchema >> populateSourceModelWith: concepts [

	self sourceModel addAll: concepts.
	self sourceModel install
]

{ #category : #accessing }
MJCSImportConceptualSchema >> resultsDictionary [
	^resultsDictionary
]

{ #category : #experiments }
MJCSImportConceptualSchema >> secondPassFrom: aCollectionOfClasses [
	
	| lcssAlgo |

	self resultsDictionary keys do: [:key |
		aCollectionOfClasses do: [:class |
			
			] ].	
]

{ #category : #'as yet unclassified' }
MJCSImportConceptualSchema >> sourceModel [
	^sourceModel
]

{ #category : #'as yet unclassified' }
MJCSImportConceptualSchema >> sourceModel: aModel [
	sourceModel := aModel
]

{ #category : #accessing }
MJCSImportConceptualSchema >> targetModel [
	^ targetModel
]

{ #category : #accessing }
MJCSImportConceptualSchema >> targetModel: aTargetModel [
	targetModel := aTargetModel 
]

{ #category : #accessing }
MJCSImportConceptualSchema >> threshold [
	^threshold 
]

{ #category : #accessing }
MJCSImportConceptualSchema >> threshold: anInteger [
	threshold := anInteger 
]
