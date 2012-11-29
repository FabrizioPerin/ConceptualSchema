Class {
	#name : #CSXMLMappingImporter,
	#superclass : #Object,
	#instVars : [
		'parser',
		'doc',
		'root',
		'targetModel',
		'lastClone'
	],
	#category : #'ConceptualSchema-Plazma-XMLElements'
}

{ #category : #'as yet unclassified' }
CSXMLMappingImporter class >> on: aMooseModel [

	^self new targetModel: aMooseModel.
]

{ #category : #'as yet unclassified' }
CSXMLMappingImporter >> createAssociationBetween: aClass and: aTable [
	| map |

	map := FAMIXMapping new.
	
	map mapSource: aClass.
	map mapTarget: aTable.

	^ map
]

{ #category : #'as yet unclassified' }
CSXMLMappingImporter >> importFrom: aStream [ 
	
	parser input: aStream.
	doc := parser parseDocument.
	root := doc root.
	
	self populateTargetModelWith: root.
	
	 ^ self targetModel
]

{ #category : #initialization }
CSXMLMappingImporter >> initialize [
	| factory |
	
	parser := XMLDOMParser new. 
	
	factory := XMLPluggableElementFactory new
				elementClass: CSAbstractXMLNode;
				handleElement: 'entity-mapping' withClass: CSEntityMappingNode;
				handleElement: 'entity' withClass: CSEntityNode.
	
	parser nodeFactory: factory. 

]

{ #category : #accessing }
CSXMLMappingImporter >> parser [
	^parser
]

{ #category : #'as yet unclassified' }
CSXMLMappingImporter >> populateTargetModelWith: aCollectionOfEnsuredNodes [
	| entityNode className classGroup tableGroup |

	entityNode := (root allElements select: [:eachElement | eachElement class = CSEntityNode]) first.
	entityNode isNil
		ifFalse: [
			className := MooseUtilities moosify: entityNode classAtt.
			classGroup := targetModel allClasses select: [:each | each mooseName asString = className ].
			tableGroup := targetModel allTables select: [:each | each name = entityNode table].
	
			(classGroup isEmpty not and: [tableGroup isEmpty not]) 
				ifTrue: [ targetModel silentlyAdd: (self createAssociationBetween: classGroup first and: tableGroup first) ] ].
	
	^targetModel
]

{ #category : #accessing }
CSXMLMappingImporter >> targetModel [
	^targetModel
]

{ #category : #accessing }
CSXMLMappingImporter >> targetModel: aMooseModel [
	targetModel := aMooseModel.
]
