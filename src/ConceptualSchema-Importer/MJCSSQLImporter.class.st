Class {
	#name : #MJCSSQLImporter,
	#superclass : #MooseSQLiteImporter,
	#category : #'ConceptualSchema-Importer'
}

{ #category : #'as yet unclassified' }
MJCSSQLImporter >> initialize [
	super initialize.

	sqlASTParser := MJCSPetitSQLiteParser new.
]
