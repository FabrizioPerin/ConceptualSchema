Extension { #name : #MooseModel }

{ #category : #'*conceptualschema-importer' }
MooseModel >> importDBStructureConceptualSchemaCustomFrom: aFileStream [
	
	| parser result ejbVer |

	UIManager default
		displayProgress: 'Importing DB From an SQL file'
		at: Sensor cursorPoint
		from: 1 
		to: 5
		during: [ :bar | 
			| importer |
			
			bar value: 2.
			bar value: 'Parsing SQL file'.
			importer := MJCSSQLImporter new targetModel: self.
			importer importSQLCreateScriptFrom: ([ aFileStream contentsOfEntireFile ]
																				ensure: [ aFileStream close ]).
			
			bar value: 4.
			bar value: 'Building relations'.
			
			bar value: 5].
	^self
]

{ #category : #'*conceptualschema-importer' }
MooseModel >> importDBXMLMappingFrom: aFolderPath [
	
	| fileSystem entries fileEntries |

	fileSystem := FileSystem disk referenceTo: aFolderPath pathName.
	entries := CollectVisitor breadthFirst: fileSystem.
	
	fileEntries := entries select: [:entry | '^.*.erm.xml$' asRegexIgnoringCase matches: entry reference name ].

	fileEntries do: [:file |
			| importer |
			importer := CSXMLMappingImporter on: self.
			importer importFrom: (StandardFileStream readOnlyFileNamed: file reference name) ].

	DialogWindow new inform: 'Import process completed'.
	
	^self
]

{ #category : #'*conceptualschema-importer' }
MooseModel >> importDBXMLMappingFromGUI [
	<menuItem: 'Import database mapping from XML files' category: 'Import / Export'>
	
	| folder |
	
	folder := UITheme builder 
		chooseDirectory: 'root folder of the project'.

	folder isNil 
		ifTrue: [ DialogWindow new alert: 'Folder not found.'.]
		ifFalse:[self importDBXMLMappingFrom: folder].
]
