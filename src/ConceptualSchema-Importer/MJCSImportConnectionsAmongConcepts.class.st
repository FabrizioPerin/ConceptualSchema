Class {
	#name : #MJCSImportConnectionsAmongConcepts,
	#superclass : #Object,
	#instVars : [
		'targetModel'
	],
	#category : #'ConceptualSchema-Importer'
}

{ #category : #'as yet unclassified' }
MJCSImportConnectionsAmongConcepts class >> on: aConceptualSchema [
	^self new targetModel: aConceptualSchema 
]

{ #category : #accessing }
MJCSImportConnectionsAmongConcepts >> createAssociationsUsing: aDictionaryOfConnections [
	| res |
	
	res := OrderedCollection new.
	
	aDictionaryOfConnections keysDo: [:key |
		(aDictionaryOfConnections at: key) do: [:value |
			| assoc |
			assoc := ConceptualSchemaConceptAssociation new.
			assoc source: key.
			assoc target: value.
			res add: assoc ] ].
	^res
	
]

{ #category : #accessing }
MJCSImportConnectionsAmongConcepts >> createConnectionsFrom: aConcept to: aCollectionOfConcepts [
	| res |
	
	res := OrderedCollection new.
	
	aCollectionOfConcepts do: [:anotherConcept |
		| map |
		map := ConceptualSchemaConceptAssociation new.
		map container: aConcept.
		map content: anotherConcept.
		res add: map.
	].

	^res
	
]

{ #category : #accessing }
MJCSImportConnectionsAmongConcepts >> findDuplicatesOn: connections [
	|res|
	res := OrderedCollection new.
	(1 to: connections size) do: [:rowIndex |
		| connection |
		connection := connections at: rowIndex.
		((rowIndex+1) to: connections size) do: [:colIndex |
			| anotherConnection |
			anotherConnection := connections at: colIndex. 
			(connection source = anotherConnection source and: [connection target = anotherConnection target]) ifTrue: [res add: anotherConnection]]].
	^res
]

{ #category : #accessing }
MJCSImportConnectionsAmongConcepts >> findRevertedConnectionsOn: connections [
	|res|
	res := OrderedCollection new.
	connections do: [:connection |
		connections do: [:anotherConnection |
			(connection source = anotherConnection target and: [connection target = anotherConnection source]) ifTrue: [res add: anotherConnection]]].
	^res
]

{ #category : #accessing }
MJCSImportConnectionsAmongConcepts >> populateConceptualScemaWithAssociationsBasedOnInvocations [
	
	| totalClassesFound concepts connectionsToCreateDictionary res |
	
	totalClassesFound := Set new.
	concepts := self targetModel allConcepts.
	connectionsToCreateDictionary := Dictionary new.
	
	(1 to: concepts size) do: [:rowIndex |
		| sourceConcept |
		sourceConcept := concepts at: rowIndex. 
		((rowIndex+1) to: self targetModel allConcepts size) do: [:colIndex |
			| targetConcept invokingClasses result |
			targetConcept := concepts at: colIndex.
			invokingClasses := ((sourceConcept mappedEntities collect: #content) select: [:ent | ent isMemberOf: FAMIXClass ] ) asSet. 	
			result := (invokingClasses flatCollect: [:each | each invokedClasses ]) asSet intersection: ((targetConcept mappedEntities collect: #content) select: [:ent | ent isMemberOf: FAMIXClass ] ) asSet.
			(result size > 0) 
				ifTrue: [
					connectionsToCreateDictionary 
						at: sourceConcept
						ifPresent: [:value | value add: targetConcept ]
						ifAbsent: [connectionsToCreateDictionary at: sourceConcept put: (Set with: targetConcept) ] ] ] ].
	

	res := self createAssociationsUsing: connectionsToCreateDictionary.
	self halt.
	self targetModel addAll: res.
	
	
]

{ #category : #accessing }
MJCSImportConnectionsAmongConcepts >> populateConceptualScemaWithAssociationsBasedOnSharedElements [
	
	| totalClassesFound concepts connectionsToCreateDictionary res |
	
	totalClassesFound := Set new.
	concepts := self targetModel allConcepts.
	connectionsToCreateDictionary := Dictionary new.
	
	(1 to: concepts size) do: [:rowIndex |
		| sourceConcept |
		sourceConcept := concepts at: rowIndex. 
		((rowIndex+1) to: self targetModel allConcepts size) do: [:colIndex |
			| targetConcept sourceConceptContent targetConceptContent result |
			targetConcept := concepts at: colIndex.
		
			sourceConceptContent := (sourceConcept mappedEntities reject: [:each | each isMemberOf: FAMIXTable]) asSet.
			targetConceptContent := (targetConcept mappedEntities reject: [:each | each isMemberOf: FAMIXTable]) asSet. 	
				
			result := sourceConceptContent intersection: targetConceptContent.
			(result size > 0) 
				ifTrue: [
					connectionsToCreateDictionary 
						at: sourceConcept
						ifPresent: [:value | value add: targetConcept ]
						ifAbsent: [connectionsToCreateDictionary at: sourceConcept put: (Set with: targetConcept) ] ] ] ].
	

	res := self createAssociationsUsing: connectionsToCreateDictionary.
	
	self targetModel silentlyAddAll: res.
	
	
]

{ #category : #accessing }
MJCSImportConnectionsAmongConcepts >> populateConceptualScemaWithAssociationsBasedOnSharedTables [
	
	| totalClassesFound concepts connectionsToCreateDictionary res |
	
	totalClassesFound := Set new.
	concepts := self targetModel allConcepts.
	connectionsToCreateDictionary := Dictionary new.
	
	(1 to: concepts size) do: [:rowIndex |
		| sourceConcept |
		sourceConcept := concepts at: rowIndex. 
		((rowIndex + 1) to: self targetModel allConcepts size) do: [:colIndex |
			| targetConcept sourceConceptContent targetConceptContent result |
			targetConcept := concepts at: colIndex.
		
			sourceConceptContent := ((sourceConcept mappedEntities collect: #content) select: [:each | each isMemberOf: FAMIXTable]) asSet.
			targetConceptContent := ((targetConcept mappedEntities collect: #content) select: [:each | each isMemberOf: FAMIXTable]) asSet. 	

			result := sourceConceptContent intersection: targetConceptContent.
			(result size > 0) 
				ifTrue: [
					connectionsToCreateDictionary 
						at: sourceConcept
						ifPresent: [:value | value add: targetConcept ]
						ifAbsent: [connectionsToCreateDictionary at: sourceConcept put: (Set with: targetConcept) ] ] ] ].
	

	res := self createAssociationsUsing: connectionsToCreateDictionary.
	self halt.
	self targetModel addAll: res.
	
	
]

{ #category : #accessing }
MJCSImportConnectionsAmongConcepts >> targetModel [
	^ targetModel
]

{ #category : #accessing }
MJCSImportConnectionsAmongConcepts >> targetModel: aConceptualSchema [
	targetModel := aConceptualSchema
]
