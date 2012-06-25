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

{ #category : #'as yet unclassified' }
ConceptualSchema >> fileoutOnCVSConceptList [
	| aStream |

	aStream := MultiByteFileStream forceNewFileNamed: 'concepts.csv'.
	
	"header"
	aStream nextPutAll: 'Concept Name Size' , ';' , 'Concept' , ';' , 'Contained Entities' , String cr.
	
	"content"
	self allConcepts do: [:concept |
		aStream nextPutAll: concept entityName size asString , ';'.
		aStream nextPutAll: concept entityName , ';'.
		concept mappedEntities do: [:entity |
			entity printOn: aStream.
			aStream nextPutAll: ', '.].
		aStream nextPutAll: String cr ].

	aStream close.
]
