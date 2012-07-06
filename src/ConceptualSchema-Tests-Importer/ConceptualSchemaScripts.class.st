Class {
	#name : #ConceptualSchemaScripts,
	#superclass : #Object,
	#category : #'ConceptualSchema-Tests-Importer'
}

{ #category : #'as yet unclassified' }
ConceptualSchemaScripts >> identifyClassesExcludedFromTheConceptsIdentificationAlgorithm [
	| importer classList classesNotInConcepts conceptualModel |
	"remember to change the moose root order if needed"

	importer :=MJCSImportConceptualSchema on: MooseModel root first.
	conceptualModel := MooseModel root second.
	
	classList := importer findModelClassesFrom: (importer importActiveRecordClassListFromFile:  '/Users/fabrizioperin/Development/Pharo/Projects/CollaborazioneArcelli/activeRecords.txt').
	classesNotInConcepts := classList select: [:each | 
		(conceptualModel allConcepts select: [:concept | concept mappedEntities anySatisfy: [:entity | entity = each] ]) size = 0 ].
		self halt.

	^classesNotInConcepts 
]
