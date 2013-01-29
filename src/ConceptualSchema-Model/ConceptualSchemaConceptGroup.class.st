Class {
	#name : #ConceptualSchemaConceptGroup,
	#superclass : #MooseGroup,
	#category : #'ConceptualSchema-Model'
}

{ #category : #'as yet unclassified' }
ConceptualSchemaConceptGroup >> averageIncomingConnectionsPerConcept [

	^ ( ( self sum: [:concept | concept incomingConceptAssociation size ] ) / self size ) asInteger
]

{ #category : #'as yet unclassified' }
ConceptualSchemaConceptGroup >> averageMappedConcepts [

	^ ( ( self sum: [:concept | concept mappedEntities size ] ) / self size ) asInteger
]

{ #category : #'as yet unclassified' }
ConceptualSchemaConceptGroup >> averageOutgoingConnectionsPerConcept [

	^ ( ( self sum: [:concept | concept outgoingConceptAssociation size ] ) / self size ) asInteger
]
