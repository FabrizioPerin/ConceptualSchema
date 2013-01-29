Class {
	#name : #ConceptualSchemaConceptGroup,
	#superclass : #MooseGroup,
	#category : #'ConceptualSchema-Model'
}

{ #category : #'as yet unclassified' }
ConceptualSchemaConceptGroup class >> writeCVSEntryHeaderOn: aStream [
	aStream nextPutAll: ('Length' , ';' , 'Concept Name' , ';' , 'Mapped Elements' , String cr).
	^aStream
]

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

{ #category : #'as yet unclassified' }
ConceptualSchemaConceptGroup >> exportListOfConceptsInCVS [
	| stream |
	
	stream := MultiByteFileStream forceNewFileNamed: 'listOfConcepts.csv'.
	self class writeCVSEntryHeaderOn: stream.
	self do: [:each | each writeSelfAsCVSEntryOn: stream].
	
	^self 
]
