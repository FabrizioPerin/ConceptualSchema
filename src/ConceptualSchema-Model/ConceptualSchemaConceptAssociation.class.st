Class {
	#name : #ConceptualSchemaConceptAssociation,
	#superclass : #BAAssociation,
	#instVars : [
		'source',
		'target',
		'directed',
		'rationale',
		'associations'
	],
	#category : #'ConceptualSchema-Model'
}

{ #category : #'as yet unclassified' }
ConceptualSchemaConceptAssociation class >> annotation [
	<MSEClass: #BAComponentAssociation super: #MJAssociation>
	<package: #'Babel-Model'>
	^self
]

{ #category : #accessing }
ConceptualSchemaConceptAssociation >> addAssociation: anAssociation [
	associations add: anAssociation
]

{ #category : #accessing }
ConceptualSchemaConceptAssociation >> associations [
	<navigation: 'Associations'>
	^ associations
]

{ #category : #accessing }
ConceptualSchemaConceptAssociation >> associations: aCollection [
	associations := aCollection
]

{ #category : #accessing }
ConceptualSchemaConceptAssociation >> from [
	^ self source
]

{ #category : #initialization }
ConceptualSchemaConceptAssociation >> initialize [
	super initialize.
	
	source := nil.
	target := nil.
	directed := false.
	rationale := ''.
]

{ #category : #accessing }
ConceptualSchemaConceptAssociation >> isDirected [
	"If false it means that the direction of the dependency does not count. If true it means that the direction is from the source to the target. Can be nil"
	^directed
]

{ #category : #accessing }
ConceptualSchemaConceptAssociation >> isDirected: aBoolean [
	directed := aBoolean.
]

{ #category : #printing }
ConceptualSchemaConceptAssociation >> printOn: aStream [

	self from isNil	
		ifFalse: [aStream nextPutAll: self from componentName].
	aStream nextPutAll: ' -> '.
	self to isNil	
		ifFalse: [aStream nextPutAll: self to componentName].
	aStream nextPutAll: ' (Concept Association)'
]

{ #category : #accessing }
ConceptualSchemaConceptAssociation >> rationale [
	^rationale
]

{ #category : #accessing }
ConceptualSchemaConceptAssociation >> rationale: aString [
	rationale := aString.
]

{ #category : #accessing }
ConceptualSchemaConceptAssociation >> source [
	<MSEProperty: #source type: #ConceptualSchemaConcept opposite: #outgoingConceptAssociation>
	<MSEComment: 'Source concept of the association. from-side of the association'>
	
	^source
]

{ #category : #accessing }
ConceptualSchemaConceptAssociation >> source: aComponent [
	source := FMMultivalueLink on: self
					update: #outgoingConceptAssociation
					from: self source
					to: aComponent
]

{ #category : #accessing }
ConceptualSchemaConceptAssociation >> target [
	<MSEProperty: #target type: #ConceptualSchemaConcept opposite: #incomingConceptAssociation>
	<MSEComment: 'Target concept of the association. to-side of the association'>
	
	^target
]

{ #category : #accessing }
ConceptualSchemaConceptAssociation >> target: aComponent [
	target := FMMultivalueLink on: self
					update: #incomingConceptAssociation
					from: self target
					to: aComponent
]

{ #category : #accessing }
ConceptualSchemaConceptAssociation >> to [
	^ self target
]
