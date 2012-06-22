Class {
	#name : #ConceptualSchema,
	#superclass : #MooseModel,
	#category : #'ConceptualSchema-Model'
}

{ #category : #'as yet unclassified' }
ConceptualSchema >> allConceptAssociations [
	<navigation: 'All Concept Associations'>

	| group |
	
	group :=  self allWithType: ConceptualSchemaConceptAssociation.
	group description: 'All Concept Associations'.
	^group
]

{ #category : #'as yet unclassified' }
ConceptualSchema >> allConcepts [
	<navigation: 'All Concepts'>

	| group |
	
	group :=  self allWithType: ConceptualSchemaConcept ofGroupClass: ConceptualSchemaConceptGroup.
	group description: 'Concepts'.
	^group
]
