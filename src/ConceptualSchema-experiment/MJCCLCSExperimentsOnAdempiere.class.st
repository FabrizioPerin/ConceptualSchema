Class {
	#name : #MJCCLCSExperimentsOnAdempiere,
	#superclass : #Object,
	#instVars : [
		'sourceModel',
		'targetModel',
		'threshold',
		'resultsDictionary'
	],
	#category : #'ConceptualSchema-experiment'
}

{ #category : #'as yet unclassified' }
MJCCLCSExperimentsOnAdempiere class >> on: aSourceModel [
	^ self new sourceModel: aSourceModel.
]

{ #category : #'as yet unclassified' }
MJCCLCSExperimentsOnAdempiere >> LCSSOn: aCollectionOfNames [

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

{ #category : #experiments }
MJCCLCSExperimentsOnAdempiere >> activeRecordExp1 [
	self threshold: 5.
	self LCSSOn: self importActiveRecordClassListFromactiveRecordsTxt.
	self resultsDictionary.
	^ self createConceptsFrom: self resultsDictionary.
]

{ #category : #'as yet unclassified' }
MJCCLCSExperimentsOnAdempiere >> applyFilterOn: aString [
	| res |
	res := aString removePrefix: '_'.
	res := res removeSuffix: '_'.
	res := res replaceAllRegex: '^.*\_.*\_' with: ''.
	
	^res
]

{ #category : #'as yet unclassified' }
MJCCLCSExperimentsOnAdempiere >> computeLCSSOf: aString and: anotherString andPrintFilteredResultsOn: aStream [
	| lcssAlgo |

	lcssAlgo := MJLongestCommonSubString 
					of: aString
					and: anotherString.
	lcssAlgo computeLCSS.
	(lcssAlgo result size > 0)
			ifTrue: [
				| res |
				res := lcssAlgo result first. 
				( res size > self threshold )
					ifTrue: [
						"(res beginsWith: '_' ) ifTrue: [self halt]. "
						res := self applyFilterOn: res.
						( res size > self threshold) 
							ifTrue: [
								lcssAlgo writeResultAsCVSEntryOn: aStream.
								^ res ] ] ]. 
	^ nil
						
]

{ #category : #experiments }
MJCCLCSExperimentsOnAdempiere >> createConceptsFrom: aDictionary [
	| concepts |

	concepts := OrderedCollection new.

	aDictionary keysAndValuesDo: [:key :value |
		| tables concept |
		tables := Set new.
		value do: [:each | tables addAll: each mappedRelationalEntities ].
		"tables size > 0 ifTrue: [self halt.]."
		concept := ConceptualSchemaConcept named: key asString containing: value.
		concept addMappedEntitiesIn: tables.
		concepts add: concept. ].
self halt.
	^ concepts
]

{ #category : #'as yet unclassified' }
MJCCLCSExperimentsOnAdempiere >> findModelClassesFrom: aCollectionOfNames [
	| result |
	
	result := OrderedCollection new.

	aCollectionOfNames do: [:aClassName |
		result addAll: (self sourceModel allClasses select: [:class | 
			class mooseName = aClassName ] ) ].

	^ result
]

{ #category : #'as yet unclassified' }
MJCCLCSExperimentsOnAdempiere >> importActiveRecordClassListFromFile: aFileName [
	| ln stream classNames |

	stream := StandardFileStream fileNamed: aFileName.

	classNames := OrderedCollection new.	
	[(ln := stream nextLine) isNil] whileFalse: [ 
		classNames add: ln].

	^classNames
]

{ #category : #'as yet unclassified' }
MJCCLCSExperimentsOnAdempiere >> importActiveRecordClassListFromactiveRecordsTxt [

	^self findModelClassesFrom: (self importActiveRecordClassListFromFile:  '/Users/fabrizioperin/Development/Pharo/Projects/CollaborazioneArcelli/activeRecordsOLD.txt')

]

{ #category : #'initialize-release' }
MJCCLCSExperimentsOnAdempiere >> initialize [ 

	resultsDictionary := Dictionary new.
	targetModel := (MooseModel new name: 'ConceptualSchema') install.
	
	^self 
]

{ #category : #accessing }
MJCCLCSExperimentsOnAdempiere >> resultsDictionary [
	^resultsDictionary
]

{ #category : #accessing }
MJCCLCSExperimentsOnAdempiere >> sourceModel [
	^ sourceModel
]

{ #category : #accessing }
MJCCLCSExperimentsOnAdempiere >> sourceModel: anObject [
	sourceModel := anObject
]

{ #category : #accessing }
MJCCLCSExperimentsOnAdempiere >> targetModel [
	^ targetModel
]

{ #category : #accessing }
MJCCLCSExperimentsOnAdempiere >> targetModel: aTargetModel [
	targetModel := aTargetModel 
]

{ #category : #accessing }
MJCCLCSExperimentsOnAdempiere >> threshold [
	^threshold 
]

{ #category : #accessing }
MJCCLCSExperimentsOnAdempiere >> threshold: anInteger [
	threshold := anInteger 
]
