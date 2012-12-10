Class {
	#name : #MJCSImportDomainModel,
	#superclass : #Object,
	#instVars : [
		'targetModel'
	],
	#category : #'ConceptualSchema-Importer'
}

{ #category : #'as yet unclassified' }
MJCSImportDomainModel class >> on: aConceptualSchema [
	^self new targetModel: aConceptualSchema 
]

{ #category : #accessing }
MJCSImportDomainModel >> findMissingClassesAgainst: aMooseModel [
	| aSet |

	aSet := Set new.
	aSet addAll: (self targetModel allConcepts collect: [:each | each mappedEntities]).

	^ aMooseModel allModelClasses asSet difference: aSet flatten asSet.
]

{ #category : #accessing }
MJCSImportDomainModel >> populateConceptualScemaWithDomainModel [
	| totalClassesFound |
	totalClassesFound := Set new.
	self targetModel allConcepts do: [:concept |
		| entitiesToAddToTheConcept |
		entitiesToAddToTheConcept := Set new.
		concept mappedEntities do: [:entity |
			 (entity isMemberOf: FAMIXClass)
				ifTrue: [
					entitiesToAddToTheConcept addAll: entity withDeepInvokingClasses] ].
		totalClassesFound addAll: entitiesToAddToTheConcept.
		concept addMappedEntitiesIn: entitiesToAddToTheConcept ].
	^ self targetModel.
]

{ #category : #accessing }
MJCSImportDomainModel >> targetModel [
	^ targetModel
]

{ #category : #accessing }
MJCSImportDomainModel >> targetModel: aConceptualSchema [
	targetModel := aConceptualSchema
]
