Class {
	#name : #ConceptualSchemaConcept,
	#superclass : #FAMIXEntity,
	#instVars : [
		'containedEntiies',
		'entityName',
		'outgoingConceptAssociation',
		'incomingConceptAssociation'
	],
	#category : #'ConceptualSchema-Model'
}

{ #category : #'as yet unclassified' }
ConceptualSchemaConcept class >> named: aString containing: aCollectionOfEntities [

	^ self new entityName: aString; addMappedEntitiesIn: aCollectionOfEntities
]

{ #category : #'as yet unclassified' }
ConceptualSchemaConcept >> addMappedEntitiesIn: aCollectionOfEntities [
	containedEntiies addAll: aCollectionOfEntities 
]

{ #category : #'as yet unclassified' }
ConceptualSchemaConcept >> addMappedEntity: anEntity [
	containedEntiies add: anEntity 
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
	containedEntiies := Set new.
	outgoingConceptAssociation := FMMultivalueLink on: self opposite: #source:.
	incomingConceptAssociation := FMMultivalueLink on: self opposite: #target:.
	
	^ self

]

{ #category : #'as yet unclassified' }
ConceptualSchemaConcept >> mappedEntities [
	<MSEProperty: #mappedEntities type: #MooseGroup>
	<MSEComment: 'Type of the elements contained into this group'>
	^containedEntiies asMooseGroup 
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
