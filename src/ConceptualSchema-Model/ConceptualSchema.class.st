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
ConceptualSchema >> fileoutConceptListAsCSV [
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

{ #category : #'as yet unclassified' }
ConceptualSchema >> fileoutConceptListAsLaTexTable [
	| aStream numberOfResults sortedConcepts index |

	numberOfResults := 10.
	index := 1.

	aStream := MultiByteFileStream forceNewFileNamed: 'conceptsList.tex'.
	
	aStream nextPutAll: 
		'\begin{table*}[h!t]' , String cr , 
		'\begin{center}' , String cr ,
		'\begin{tabular}{c|l|m{0.65\textwidth}}' , String cr.

	"header"
	aStream nextPutAll: 'Concept Name Size' , String tab , '& ' , 'Concept' , String tab , '& ' , 'Contained Entities' , '\\' , String cr.
	
	"content"
	sortedConcepts := (self allConcepts sorted: [:a :b | a entityName size > b entityName size ]).
	sortedConcepts do: [:concept |
		aStream nextPutAll: concept entityName size asString , String tab , '&'.
		aStream nextPutAll: concept entityName , String tab , '& '.
		
		concept mappedEntities first printOn: aStream.
		(2 to: concept mappedEntities size) do: [:entityIndex |
			aStream nextPutAll: ', '.
			(concept mappedEntities at: entityIndex) mooseNameOn: aStream ].

		aStream nextPutAll: '\\'.
		aStream nextPutAll: String cr. 
		
		(index < numberOfResults) ifFalse: [			
			aStream nextPutAll: 
			'\end{tabular}' , String cr , 
			'\caption{First' , numberOfResults asString  , 'concepts and content}' , String cr ,
			'\label{tab:conceptList}' , String cr ,
			'\end{center}' , String cr ,
			'\end{table*}' , String cr.

			aStream close. 
			^index ].
		
		index := index + 1 ].

	
]
