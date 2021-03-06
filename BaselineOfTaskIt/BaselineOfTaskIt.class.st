Class {
	#name : #BaselineOfTaskIt,
	#superclass : #BaselineOf,
	#category : #BaselineOfTaskIt
}

{ #category : #'development support' }
BaselineOfTaskIt class >> DevelopmentSupport [

"See the methods in the 'development support' category on the class-side of MetacelloBaseConfiguration. Decide what development support methods you would like to use and copy them the the class-side of your configuration."
	<apiDocumentation>

]

{ #category : #private }
BaselineOfTaskIt class >> baseConfigurationClassIfAbsent: aBlock [

	^Smalltalk
		at: #MetacelloBaseConfiguration
		ifAbsent: [ 
			self ensureMetacelloBaseConfiguration.
			Smalltalk at: #MetacelloBaseConfiguration ifAbsent: aBlock ].

]

{ #category : #catalog }
BaselineOfTaskIt class >> catalogContactInfo [
	^ 'santiagobragagnolo@gmail.com'
]

{ #category : #catalog }
BaselineOfTaskIt class >> catalogDescription [
	^ 'Task & Jobs oriented multiprocessing framework. Check for nicely showed documentation at https://github.com/sbragagnolo/taskit-2/ :)'
]

{ #category : #catalog }
BaselineOfTaskIt class >> catalogKeywords [
	^ {'multiprocessing'. 'futures'. 'tasks'. 'services'. }
]

{ #category : #private }
BaselineOfTaskIt class >> ensureMetacelloBaseConfiguration [

	Smalltalk
		at: #MetacelloBaseConfiguration
		ifAbsent: [ 
			| repository version |
			repository := MCHttpRepository location: 'http://seaside.gemstone.com/ss/metacello' user: '' password: ''.
			repository
				versionReaderForFileNamed: 'Metacello-Base-DaleHenrichs.2.mcz'
				do: [ :reader | 
					version := reader version.
					version load.
					version workingCopy repositoryGroup addRepository: repository ] ]
]

{ #category : #'metacello tool support' }
BaselineOfTaskIt class >> isMetacelloConfig [
	"Answer true and the Metacello tools will operate on you"
	
	^true
]

{ #category : #loading }
BaselineOfTaskIt class >> load [
	"Load the #stable version defined for this platform. The #stable version is the version that is recommended to be used on this platform."

	"self load"

	<apiDocumentation>
	^(self project version: #stable) load
]

{ #category : #loading }
BaselineOfTaskIt class >> loadBleedingEdge [
	"Load the latest versions of the mcz files defined for this project. It is not likely that the #bleedingEdge has been tested."

	"self loadBleedingEdge"

	<apiDocumentation>
	^(self project version: #bleedingEdge) load
]

{ #category : #loading }
BaselineOfTaskIt class >> loadDevelopment [
	"Load the #development version defined for this platform. The #development version will change over time and is not expected to be stable."

	"self loadDevelopment"

	<apiDocumentation>
	^(self project version: #development) load
]

{ #category : #baseline }
BaselineOfTaskIt >> baseline: spec [
	<baseline>
	spec
		for: #('pharo7.x' 'pharo8.x')
			do: [ spec
				baseline: 'ParametrizedTests'
					with: [ spec repository: 'github://tesonep/ParametrizedTests' ];
				baseline: #Pragmatic
					with: [ spec repository: 'github://sbragagnolo/pragmatic/src' ];
				package: #TaskIt  with: [ spec requires: #( ParametrizedTests) ];
				package: #ActIt with: [ spec requires: #('TaskIt') ];
				package: #'TaskIt-Tests' with: [ spec requires: #('TaskIt') ];
				package: #TaskItRetry with: [ spec requires: #('TaskIt') ];
				package: #'TaskItRetry-Tests'
					with: [ spec requires: #('TaskItRetry') ];
				package: #TaskItProcesses with: [ spec requires: #('TaskIt') ];
				package: #'TaskItProcesses-Tests'
					with: [ spec requires: #('TaskItProcesses') ];
				package: #TaskItBrowser
					with: [ spec requires: #('TaskItProcesses') ];
				package: #TaskItDebugger
					with: [ spec requires: #('TaskItProcesses') ];
				package: #'TaskItDebugger-Tests'
					with: [ spec requires: #('TaskItDebugger') ].
			spec
				group: 'minimal' with: #('TaskIt' 'ActIt');
				group: 'default'
					with:
					#('minimal' 'TaskItProcesses' 'TaskItRetry' 'TaskItDebugger' 'TaskIt-Tests' 'TaskItRetry-Tests' 'TaskItProcesses-Tests' 'TaskItDebugger-Tests' Pragmatic);
				group: 'debug' with: #('minimal' 'TaskItDebugger');
				group: 'tests'
					with:
					#('default' 'TaskIt-Tests' 'TaskItRetry-Tests' 'TaskItProcesses-Tests' 'TaskItDebugger-Tests');
				group: 'development' with: #('default' 'debug' 'tests') ];
		for: #'pharo6.1.x'
			do: [ spec
				package: #TaskIt;
				package: #'TaskIt-Tests' with: [ spec requires: #('TaskIt') ];
				package: #TaskItRetry with: [ spec requires: #('TaskIt') ];
				package: #'TaskItRetry-Tests'
					with: [ spec requires: #('TaskItRetry') ];
				package: #TaskItProcesses with: [ spec requires: #('TaskIt') ];
				package: #'TaskItProcesses-Tests'
					with: [ spec requires: #('TaskItProcesses') ];
				package: #TaskItBrowser
					with: [ spec requires: #('TaskItProcesses') ];
				package: #TaskItDebugger
					with: [ spec requires: #('TaskItProcesses') ];
				package: #'TaskItDebugger-Tests'
					with: [ spec requires: #('TaskItDebugger') ].
			spec
				group: 'minimal' with: #('TaskIt');
				group: 'default'
					with:
					#('minimal' 'TaskItProcesses' 'TaskItRetry' 'TaskItDebugger' 'TaskIt-Tests' 'TaskItRetry-Tests' 'TaskItProcesses-Tests' 'TaskItDebugger-Tests');
				group: 'debug' with: #('minimal' 'TaskItDebugger');
				group: 'tests'
					with:
					#('default' 'TaskIt-Tests' 'TaskItRetry-Tests' 'TaskItProcesses-Tests' 'TaskItDebugger-Tests');
				group: 'development' with: #('default' 'debug' 'tests') ]
]
