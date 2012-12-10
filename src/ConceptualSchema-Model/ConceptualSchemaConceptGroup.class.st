Class {
	#name : #ConceptualSchemaConceptGroup,
	#superclass : #MooseGroup,
	#category : #'ConceptualSchema-Model'
}

{ #category : #'as yet unclassified' }
ConceptualSchemaConceptGroup >> averageConnectionsPerConcept [

	^ ( ( self sum: [:concept | concept mappedEntities size ] ) / self size ) asInteger
]
