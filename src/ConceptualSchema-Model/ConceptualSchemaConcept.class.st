Class {
	#name : #ConceptualSchemaConcept,
	#superclass : #FAMIXEntity,
	#instVars : [
		'entityName',
		'outgoingConceptAssociation',
		'incomingConceptAssociation',
		'containedEntities'
	],
	#category : #'ConceptualSchema-Model'
}

{ #category : #'as yet unclassified' }
ConceptualSchemaConcept class >> named: aString containing: aCollectionOfEntities [

	^ self new entityName: aString; addMappedEntitiesIn: aCollectionOfEntities
]

{ #category : #'as yet unclassified' }
ConceptualSchemaConcept >> addMappedEntitiesIn: aCollectionOfEntities [
	containedEntities addAll: aCollectionOfEntities 
]

{ #category : #'as yet unclassified' }
ConceptualSchemaConcept >> addMappedEntity: anEntity [
	containedEntities add: anEntity 
]

{ #category : #'as yet unclassified' }
ConceptualSchemaConcept >> entityName [
	^entityName
]

{ #category : #'as yet unclassified' }
ConceptualSchemaConcept >> entityName: aString [
	entityName := aString
]

{ #category : #'as yet unclassified' }
ConceptualSchemaConcept >> incomingConceptAssociation [
	<MSEProperty: #incomingConceptAssociation type: #ConceptualSchemaConceptAssociation opposite: #target> <multivalued>  <derived>
	<MSEComment: 'Association with another concept'>
	
	^incomingConceptAssociation  
]

{ #category : #'as yet unclassified' }
ConceptualSchemaConcept >> initialize [

	super initialize.
	containedEntities := Set new.
	outgoingConceptAssociation := FMMultivalueLink on: self opposite: #source:.
	incomingConceptAssociation := FMMultivalueLink on: self opposite: #target:.
	
	^ self

]

{ #category : #'as yet unclassified' }
ConceptualSchemaConcept >> mappedEntities [
	<MSEProperty: #mappedEntities type: #MooseGroup>
	<MSEComment: 'Type of the elements contained into this group'>
	^containedEntities asMooseGroup 
]

{ #category : #'as yet unclassified' }
ConceptualSchemaConcept >> mooseNameOn: aStream [
	self printOn: aStream
]

{ #category : #'as yet unclassified' }
ConceptualSchemaConcept >> outgoingConceptAssociation [
	<MSEProperty: #outgoingConceptAssociation type: #ConceptualSchemaConceptAssociation opposite: #source> <multivalued>  <derived>
	<MSEComment: 'Association with another concept'>
	
	^outgoingConceptAssociation 
]

{ #category : #'as yet unclassified' }
ConceptualSchemaConcept >> printOn: aStream [
	aStream nextPutAll: self entityName.
	aStream nextPutAll: ' (Concept)'
]

{ #category : #'as yet unclassified' }
ConceptualSchemaConcept >> writeSelfAsCVSEntryOn: aStream [
	
	aStream nextPutAll: (self entityName size asString , ';' , self entityName , ';' , ((self mappedEntities inject: '' into: [:tot :each | tot , each name asString , ', '] ) removeSuffix: ', ') , String cr).
	^aStream 
]
