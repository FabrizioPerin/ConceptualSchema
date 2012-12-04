Class {
	#name : #MJCSPetitSQLiteParserTest,
	#superclass : #PetitSQLiteASTNodesParserTest,
	#category : #'ConceptualSchema-Tests-Importer'
}

{ #category : #'as yet unclassified' }
MJCSPetitSQLiteParserTest >> parserClass [
	^MJCSPetitSQLiteParser 
]

{ #category : #'as yet unclassified' }
MJCSPetitSQLiteParserTest >> testKey [
		
	self
		parse: 'key'
		rule: #key.
	
	self
		parse: 'kEy '
		rule: #key.
		
]

{ #category : #'as yet unclassified' }
MJCSPetitSQLiteParserTest >> testTableConstraintPrimaryKeyPartForMYSQLOneColumn [

	self 
		parse: 'key wahtever (column)'
		rule: #tableConstraintPrimaryKeyOrIndexPartForMYSQL.
		
self assert: (result isMemberOf: SQLTableConstraintNode).
	self assert: result isPKConstraint.
	self deny: result isFKConstraint.
	self assert: (result pkColumnNames size = 1).
	self assert: (result pkColumnNames first = 'column').
]

{ #category : #'as yet unclassified' }
MJCSPetitSQLiteParserTest >> testTableConstraintPrimaryKeyPartForMYSQLTwoColumns [

	self 
		parse: 'key wahtever (column1 , column2)'
		rule: #tableConstraintPrimaryKeyOrIndexPartForMYSQL.
		
self assert: (result isMemberOf: SQLTableConstraintNode).
	self assert: result isPKConstraint.
	self deny: result isFKConstraint.
	self assert: result pkColumnNames size equals:  2.
	self assert: result pkColumnNames first equals: 'column1'.
	self assert: result pkColumnNames second equals: 'column2'.
]
