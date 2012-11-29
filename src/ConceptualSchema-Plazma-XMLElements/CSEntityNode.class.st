Class {
	#name : #CSEntityNode,
	#superclass : #CSEntityMappingNode,
	#category : #'ConceptualSchema-Plazma-XMLElements'
}

{ #category : #'as yet unclassified' }
CSEntityNode >> classAtt [
	^self attributes at: 'class' ifAbsent: [nil].
]

{ #category : #'as yet unclassified' }
CSEntityNode >> table [
	^self attributes at: 'table' ifAbsent: [nil].
]
