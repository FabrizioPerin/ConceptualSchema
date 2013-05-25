Class {
	#name : #ConfigurationOfConceptualSchema,
	#superclass : #Object,
	#instVars : [
		'project'
	],
	#category : #ConfigurationOfConceptualSchema
}

{ #category : #'as yet unclassified' }
ConfigurationOfConceptualSchema class >> ensureMetacello [
	Smalltalk at: #MetacelloProject ifAbsent: [
		Gofer new
				url: 'http://seaside.gemstone.com/ss/metacello';
				package: 'ConfigurationOfMetacello';
				load.
		(Smalltalk at: #ConfigurationOfMetacello) loadLatestVersion ]
]

{ #category : #'as yet unclassified' }
ConfigurationOfConceptualSchema class >> isMetacelloConfig [
	"Answer true and the Metacello tools will operate on you"
	
	^true
]

{ #category : #'as yet unclassified' }
ConfigurationOfConceptualSchema class >> loadDefault [

	(self project version: 'default') load.
	
	Categorizer sortAllCategories.
]

{ #category : #'as yet unclassified' }
ConfigurationOfConceptualSchema class >> project [

	^self new project
]

{ #category : #'as yet unclassified' }
ConfigurationOfConceptualSchema >> default: spec [ 
	<version: 'default'>
	
	spec for: #common do: [
		spec blessing: #default.
		spec description: ''.
		spec repository: 'http://www.smalltalkhub.com/mc/FabrizioPerin/ConceptualSchema/main'.

		spec 
			package: 'ConceptualSchema-Model';
			package: 'ConceptualSchema-Importer';
			package: 'ConceptualSchema-experiment';
			package: 'ConceptualSchema-Plazma-XMLElements';
			package: 'Moose-JEE-DesignPattern'.

		"tests"
		spec 
			package: 'ConceptualSchema-Tests-Importer' with: [spec requires: #('ConceptualSchema-Importer').];
			package: 'Moose-JEE-Tests-DesignPattern'.
	]
]

{ #category : #'as yet unclassified' }
ConfigurationOfConceptualSchema >> project [

	^ project ifNil: [ | constructor |
		"Bootstrap Metacello if it is not already loaded"
		self class ensureMetacello.
		"Construct Metacello project"
		constructor := (Smalltalk at: #MetacelloVersionConstructor) on: self.
		project := constructor project.
		project]
]
