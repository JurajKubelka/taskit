"
I represent a ready to run task. A ready task will start running when asked, or be cancelled immediately if cancelled.
"
Class {
	#name : #TKTReadyTaskState,
	#superclass : #TKTTaskState,
	#category : #'TaskIt-Kernel'
}

{ #category : #cancelling }
TKTReadyTaskState >> cancelTaskExecution: aTaskExecution reason: aReason [

	aTaskExecution setCancelStateWithReason: aReason
]

{ #category : #executing }
TKTReadyTaskState >> performTaskExecution: aTaskExecution [
	aTaskExecution setRunningState.
	[ aTaskExecution doExecuteTask ]
		"If there was an exception during task execution the state will never
		be set from #running to #finished.
		See https://github.com/feenkcom/gtoolkit/issues/1823"
		ensure: [ aTaskExecution setFinishedState ]
]
