"
I am a task executer paired with a worker. A worker-workerProcess pair shares the same taskQueue so the worker can schedule on it and I can execute them.

The reason I exist is that if the Pharo process executing the worker's task has a reference to the worker, then the worker may never be collected. If this happens, a memory leak could occur if we lose every other reference to the worker, since the worker nor the process will ever be collected.

We avoid this problem by only sharing the task queue. Then, the process does not have a strong reference to the worker and:
  - the worker can be garbage collected
  - if the worker (and all its associated futures) are garbage collected, since the worker process is unreachable we can schedule a #stop task. See method TKTWorker>> #finalize.
"
Class {
	#name : #TKTWorkerProcess,
	#superclass : #TKTAbstractExecutor,
	#instVars : [
		'taskQueue',
		'name',
		'process',
		'currentTaskExecution',
		'processPriority'
	],
	#category : #'TaskIt-Worker'
}

{ #category : #'start-stop' }
TKTWorkerProcess >> currentTaskExecution [
	^ currentTaskExecution
]

{ #category : #'start-stop' }
TKTWorkerProcess >> executeTask: aTaskExecution [
	currentTaskExecution := aTaskExecution.
	super executeTask: aTaskExecution.
	currentTaskExecution := nil.
	"The task may changes the process priority.  Reset it as a matter of course."
	processPriority ifNotNil:
		[ Processor activeProcess priority: processPriority ].
]

{ #category : #'start-stop' }
TKTWorkerProcess >> isFree [
	^ currentTaskExecution isNil
]

{ #category : #testing }
TKTWorkerProcess >> isRunning [
	
	^ process notNil and: [ process isTerminated not ]
]

{ #category : #'start-stop' }
TKTWorkerProcess >> kill [

	self stop.
	taskQueue := nil. 

]

{ #category : #accessing }
TKTWorkerProcess >> name [ 
	
	^ name
]

{ #category : #accessing }
TKTWorkerProcess >> name: aString [ 
	
	name := aString
]

{ #category : #testing }
TKTWorkerProcess >> process [

	^ process
]

{ #category : #accessing }
TKTWorkerProcess >> processPriority [
	^ processPriority
]

{ #category : #accessing }
TKTWorkerProcess >> processPriority: anObject [
	processPriority := anObject
]

{ #category : #'start-stop' }
TKTWorkerProcess >> start [
	process := TKTConfiguration processProvider
		createProcessDoing: (MessageSend receiver: self selector: #workerLoop)
		named: name
]

{ #category : #'start-stop' }
TKTWorkerProcess >> stop [
	process ifNotNil: [
		process terminate.
		process := nil ]
]

{ #category : #accessing }
TKTWorkerProcess >> taskQueue [
	^ taskQueue
]

{ #category : #accessing }
TKTWorkerProcess >> taskQueue: aQueue [
	taskQueue := aQueue
]

{ #category : #'start-stop' }
TKTWorkerProcess >> workerLoop [
	[ self executeTask: taskQueue next ] repeat
]
